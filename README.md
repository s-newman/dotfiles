dotfiles
========

Various user configuration files.

Installation
------------

You need to [install YCM](https://github.com/ycm-core/YouCompleteMe#full-installation-guide)
for the YouCompleteMe vim plugin. I usually install it with all available
completers, because why not?

Also, [vim-plug](https://github.com/junegunn/vim-plug) needs to be installed to
the `.vim/autoload/` directory.

Notes
-----

### Colors

Colors are escaped with `\e[Xm\[` escape values, where X is the color code.

| Color  | Foreground code | Background code |
|--------|-----------------|-----------------|
| Black  | 30              | 40              |
| Red    | 31              | 41              |
| Green  | 32              | 42              |
| Yellow | 33              | 43              |
| Blue   | 34              | 44              |
| Purple | 35              | 45              |
| Cyan   | 36              | 46              |
| White  | 37              | 47              |

Color sequences can be reset with `\e[0m`, and text can be bolded with `\e[1m`.

### Neat variables
Notes from the [bash manual](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html)

`$LINENO` - current line number in source file being executed. could be useful
for customizing `$PS4`

`$COLUMNS` - current width of the terminal

`$EUID` - effective user ID of the current user

`$PROMPT_COMMAND` - command to execute before printing `$PS1`

`$PS0` - expanded like `$PS1` and displayed after reading a command, but before
executing the command

`$PS1` - the normal prompt

`$PS2` - continuation prompt after typing incomplete commands

`$PS3` - prompt for the `select` command

`$PS4` - debug prompt printed before the command line when `-x` is set

`$SECONDS` - number of seconds since the shell was started. Assigning a value
to it will restart the count at the assigned value
