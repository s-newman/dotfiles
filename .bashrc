# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# ^that's just giving us tab completion

##
# START CUSTOM STUFF
##

# Foreground color shortcuts
BLK_FG='30'
RED_FG='31'
GRN_FG='32'
YLW_FG='33'
BLU_FG='34'
PRP_FG='35'
CYN_FG='36'
WHT_FG='37'

# Background color shortcuts
BLK_BG='40'
RED_BG='41'
GRN_BG='42'
YLW_BG='43'
BLU_BG='44'
PRP_BG='45'
CYN_BG='46'
WHT_BG='47'

# Other shortcuts
RST='0'     # Reset all attributes
BLD='1'     # Bold text
FNT='2'     # Faint text
ITL='3'     # Italicsr
UND='4'     # Underlined
SBL='5'     # Slow blink

# Often-used unicode characters - thanks for the names, Mom!
RALPH='\xe2\x94\x8c'    # ┌
FRANK='\xe2\x94\x94'    # └
DASH='\xe2\x94\x80'     # ─

# Get the color for the last status code
function retcode()
{
    if [ "$EXIT_CODE" -eq 0 ]
    then
        echo ${BLK_FG}
    else
        echo ${RED_FG}
    fi
}

# Get current branch in git repo
function parse_git_branch() {
    # Determines the current git branch, if any
    BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/^* \(.*\)/\1/')
    # Only do stuff if the branch string is not null
    if [ ! "${BRANCH}" == "" ]
    then
        # Checks if there are uncommitted changes in tracked files
        git diff-index --quiet HEAD --
        DIRTY=$?

        # Checks if there are untracked files
        UNTRACKED=$(git status --porcelain 2>/dev/null | grep "^??" | wc -l)

        # Set the color for the current status
        if [ ! $UNTRACKED -eq 0 ]
        then
            STATUS=${RED_FG}
        elif [ ! $DIRTY -eq 0 ]
        then
            STATUS=${YLW_FG}
        else
            STATUS=${GRN_FG}
        fi
        
        # Return the prompt bit
        # echo -e "\001\e[$(code_color)m\002(\001\e[${STATUS}m\002${BRANCH}\001\e[$(code_color)m\002)"
        echo -en "${DASH}($(esc ${STATUS})${BRANCH}"
        echo -en "$(esc $(retcode)))"
    fi
}

# Get prompt ending character
function end_char() {
    # Set to '#' if root, otherwise use '$"
    if [ "$EUID" -ne 0 ]
    then
        echo "$"
    else
        echo "#"
    fi
}

# Aliases, breh
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

##
# Dank AF prompt
##
# Make sure EXIT_CODE is set
PS1="\[\e[${BLD};\$(retcode)m\]┌("       # Start of first line
PS1="${PS1}\[\e[${PRP_FG}m\]\u@\h"              # username@hostname
PS1="${PS1}\[\e[\$(retcode)m\])─("         # Separator
PS1="${PS1}\[\e[${PRP_FG}m\]\w"         # Directory
PS1="${PS1}\[\e[\$(retcode)m\])\n"      # Separator
PS1="${PS1}\[\e[${BLD};\$(retcode)m\]└─"       # Start of second line
PS1="${PS1}\$(end_char)\[\e[${RST}m\] " # Second line

# Save the exit code for later use
PROMPT_COMMAND='EXIT_CODE=$?'
