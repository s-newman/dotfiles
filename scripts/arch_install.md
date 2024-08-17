# Arch Installation

First, make sure you have the latest Arch install ISO. [RIT's mirrors](https://mirrors.rit.edu/archlinux/iso/) are a good source, and not just because I'm an alum.

## Base Setup

Boot into the ISO in UEFI mode and make sure EFI variables are available:
```shell
# directory must exist with contents
ls /sys/firmware/efi/efivars
```

Make sure you have networking:
```shell
ping -c 1 archlinux.org
```

Update the system clock with systemd-timesyncd:
```shell
timedatectl set-ntp true
```

Format the primary disk. The following sets up a 512MiB EFI boot partition and a LUKS-encrypted root partition that takes up the rest of the disk.
```shell
# replace /dev/sda as necessary
# can run `parted /dev/sda` to get a prompt
parted /dev/sda mklabel gpt
parted /dev/sda mkpart primary fat32 1MiB 5121MiB # This will make it 5GiB instead of 5GiB - 1 MiB
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary 5121MiB 100%
# (parted) quit

# Set up LUKS
cryptsetup -yv luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptroot

# Set up LVM
pvcreate /dev/mapper/cryptid
vgcreate vgmain /dev/mapper/cryptid
lvcreate -L 20G vgmain -n lvswap
lvcreate -l 100%FREE vgmain -n lvbutter
mkswap /dev/vgmain/lvswap
mkfs.btrfs /dev/vgmain/lvbutter

# Set up butter subvolumes
mount /dev/vgmain/lvbutter /mnt
mkdir /mnt/arch
btrfs subvolume create /mnt/arch/@root
btrfs subvolume create /mnt/arch/@home
umount /mnt
mount -o subvol=arch/@root /dev/vgmain/lvbutter /mnt
mount --mkdir -o subvol=arch/@home /dev/vgmain/lvbutter /mnt/home

# Boot partition
mkfs.fat -F 32 /dev/sda1
mount --mkdir /dev/sda1 /mnt/boot

# Make sure everything looks right
parted /dev/sda print
lsblk
```

Set up mirrorlist:
```shell
reflector --ipv4 --country US --protocol https --save /etc/pacman.d/mirrorlist
```

Configure parallel downloading to speed up the first-time installation. In `/etc/pacman.conf`, uncomment the following line:
```conf
#ParallelDownloads = 5
```
> We'll have to do this again later after `pacstrap` because this config file doesn't get copied over during the installation.

Install base set of packages
```shell
pacstrap /mnt base base-devel linux linux-firmware intel-ucode btrfs-progs lvm2 sudo zsh tmux vi vim networkmanager wpa_supplicant man-db man-pages texinfo gnome htop python bind tree firefox noto-fonts docker docker-compose docker-buildx git plymouth
```

Other possibly useful packages (depends on environment):
- `keepassxc`
- `networkmanager-openvpn`
- `signal-desktop`

Generate fstab
```shell
genfstab -U /mnt >> /mnt/etc/fstab
```

## Chroot Steps

Enter the chroot with `arch-chroot /mnt` and continue with these steps within the chroot.

Configure timezone and hardware clock
```shell
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
```

Uncomment the following line in `/etc/locale.gen`:
```
#en_US.UTF-8 UTF-8
```

Generate locales:
```shell
locale-gen
```

Put your desired hostname in `/etc/hostname`, and then put the following in your `/etc/hosts`:
```
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1	localhost
127.0.1.1	hostname

::1		localhost
```
> Remember to replace `hostname` in the above with your actual hostname!

Set up your user:
```shell
useradd -c "Local Administrator" -d /home/ladmin -G wheel,docker,wireshark,vboxusers -m --shell /bin/zsh ladmin
passwd ladmin
```

Enable passwordless SSH by creating a file at `/etc/sudoers.d/10-wheel` with the following content:
```
%wheel ALL=(ALL:ALL) ALL
```

## User Configuration

Switch to your user with `su ladmin` and continue with the following steps.

Make sure passwordless sudo works:
```shell
sudo su
exit
```

Install and configure yay
```shell
git clone https://aur.archlinux.org/yay
cd yay
makepkg -sirf
cd ~
rm -rf yay
yay --answerclean All --answerdiff None --answeredit None --removemake --cleanafter --save
```

Install AUR packages
```shell
yay -S visual-studio-code-bin nerd-fonts-complete
```

## Boot Steps

Return to the root user within the chroot and finish with the following steps.

Configure your initramfs hooks. The HOOKS line in `/etc/mkinitcpio.conf` should look like this:
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap plymouth block encrypt lvm2 filesystems fsck)
```

...and the MODULES line should look like this:
```
MODULES=(btrfs)
```

Build initramfs:
```shell
mkinitcpio -P
```

Enable parallel pacman downloads by uncommenting the following line in `/etc/pacman.conf`:
```shell
#ParallelDownloads = 5
```

Install systemd-boot:
```shell
bootctl install
systemctl enable systemd-boot-update.service
```

Add the following content to `/boot/loader/loader.conf`:
```
timeout 5
console-mode 2
```

Add the following content to `/boot/loader/entries/arch.conf`:
```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options cryptdevice=UUID=<disk-uuid>:cryptroot root=/dev/vgmain/lvbutter resume=/dev/vgmain/lvswap rootflags=subvol=arch/@root quiet splash
```

Then replace `<disk-uuid>` in vim by running the vim command `:r! blkid -o value /dev/nvme0n1p2 | head -n 1` to insert the partition UUID for your LUKS partition and move it into place with some vim-fu.

Enable on-boot services:
```shell
systemctl enable gdm NetworkManager wpa_supplicant docker
```

## Final Steps

Exit the chroot, unmount everything with `umount -R /mnt`, reboot, and pray it boots properly!

Set up dotfiles and scripts
```shell
cd ~
mkdir src
cd src
git clone https://github.com/s-newman/dotfiles
cd dotfiles
./install.sh
cd ~
```

Open the Settings app and configure:
- Region & Language
  - Language = English
- Date & Time
  - Automatic Date & Time = Enabled

Set up git config:
```shell
git config --global pull.ff "only"
git config --global init.defaultBranch "main"
git config --global user.name "Your Name"
git config --global user.email "youremail@example.com"
```

Restart and enjoy your installation!