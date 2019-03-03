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

# Set shortcuts for various \e[Xm escape values
ORANGE='38;5;166'
BLUE='38;5;75'
RED='38;5;124'
GREEN='38;5;40'
YELLOW='38;5;178'
GRAY='38;5;240'
BOLD='1'
RST='\e[0m'

# Get the color for the last status code
function code_color() {
    if [ "$EXIT_CODE" -eq 0 ]
    then
        echo $GRAY
    else
        echo $RED
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
            STATUS=$RED
        elif [ ! $DIRTY -eq 0 ]
        then
            STATUS=$YELLOW
        else
            STATUS=$GREEN
        fi
        
        # Return the prompt bit
        echo -e "\001\e[$(code_color)m\002(\001\e[${STATUS}m\002${BRANCH}\001\e[$(code_color)m\002)"
    fi
}

# Get prompt ending character
function end_char() {
    # Set to '#' if root, otherwise use '$"
    if [ "$EUID" -ne 0 ]
    then
        END="$"
    else
        END="#"
    fi

    LAST_CODE=$(code_color)

    # Return that shizznits
    echo -e "\001\e[${LAST_CODE}m\002${END}"
}

# Aliases, breh
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

##
# Dank AF prompt
##
PS1="\[\e[${BOLD};\$(code_color)m\]["       # First bracket w/status code color
PS1="$PS1\[\e[${ORANGE}m\]\u@\h "           # user@host
PS1="$PS1\[\e[${BLUE}m\]\W"                 # dir
PS1="$PS1\[\e[\$(code_color)m\]]"           # Second bracket w/status code color
PS1="$PS1\$(parse_git_branch)"          # Git branch portion w/dirty notifier
PS1="$PS1\$(end_char)\[\e[0m\] "            # End char w/status code color

# Save the exit code for later use
PROMPT_COMMAND='EXIT_CODE=$?'
