# --- Default content ---------------------------------------------------------

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

# --- Prompt customization ----------------------------------------------------

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
function gitparse() {
    # Only echo things if we're in a git branch
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]
    then
        ### VARIABLES ###

        # Determine the branch name
        BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

        # Count the number of unstaged changes
        UNSTAGED=$(git status --porcelain | grep -E "^.M.*$" | wc -l)

        # Count the number of staged changes
        STAGED=$(git status --porcelain | grep -E "^M.*$" | wc -l)

        # Count the number of untracked files
        UNTRACKED=$(git status --porcelain | grep -E "^\?\?.*$" | wc -l)

        # Count the number of added files
        ADDED=$(git status --porcelain | grep -E "^A.*$" | wc -l)

        # Count the number of deleted files
        DELETED=$(git status --porcelain | grep -E "^.D.*$" | wc -l)

        # Count the number of stash entries
        STASH=$(git stash list | wc -l)

        # Count the number of merge conflicts
        CONFLICTS=$(git diff --name-only --diff-filter=U | wc -l)

        ### PRINTING ###

        echo -en "─(\001\e[${PRP_FG}m\002"  # Start separator

        echo -en "${BRANCH}"        # branch

        # Only count unpushed/pulled commits if this branch has an upstream
        if $(git config --get branch.${BRANCH}.merge &>/dev/null)
        then
            # Count the number of unpushed commits
            AHEAD=$(git rev-list --count @{u}.. 2>/dev/null)

            # Count the number of unpulled commits
            BEHIND=$(git rev-list --count ..@{u} 2>/dev/null)

            if [ "${AHEAD}" -gt "0" ]   # Unpushed commits
            then
                echo -en "\001\e[$(retcode)m\002|\001\e[${CYN_FG}m\002"
                echo -en "⌃${AHEAD}"
                echo -en "\001\e[$(retcode)m\002"
            fi

            if [ "${BEHIND}" -gt "0" ]   # Unpulled commits
            then
                echo -en "\001\e[$(retcode)m\002|\001\e[${CYN_FG}m\002"
                echo -en "⌄${BEHIND}"
                echo -en "\001\e[$(retcode)m\002"
            fi
        else
            echo -en "\001\e[$(retcode)m\002|\001\e[${CYN_FG}m\002"
            echo -en "L"
            echo -en "\001\e[$(retcode)m\002"
        fi

        if [ "${STASH}" -gt "0" ]  # Stash entries
        then
            echo -en "\001\e[$(retcode)m\002|\001\e[${BLU_FG}m\002"
            echo -en "⚑${STASH}"
            echo -en "\001\e[$(retcode)m\002"
        fi

        if [ "${STAGED}" -gt "0" ]  # Staged changes
        then
            echo -en "\001\e[$(retcode)m\002|\001\e[${GRN_FG}m\002"
            echo -en "✔${STAGED}"
            echo -en "\001\e[$(retcode)m\002"
        fi

        if [ "${ADDED}" -gt "0" ]   # Added files
        then
            echo -en "\001\e[$(retcode)m\002|\001\e[${GRN_FG}m\002"
            echo -en "+${ADDED}"
            echo -en "\001\e[$(retcode)m\002"
        fi

        if [ "${UNSTAGED}" -gt "0" ]    # Unstaged changes
        then
            echo -en "\001\e[$(retcode)m\002|\001\e[${YLW_FG}m\002"
            echo -en "∆${UNSTAGED}"
            echo -en "\001\e[$(retcode)m\002"
        fi

        if [ "${UNTRACKED}" -gt "0" ]   # Untracked files
        then
            echo -en "\001\e[$(retcode)m\002|\001\e[${RED_FG}m\002"
            echo -en "✗${UNTRACKED}"
            echo -en "\001\e[$(retcode)m\002"
        fi

        if [ "${DELETED}" -gt "0" ]     # Deleted files
        then
            echo -en "\001\e[$(retcode)m\002|\001\e[${RED_FG}m\002"
            echo -en "-${DELETED}"
            echo -en "\001\e[$(retcode)m\002"
        fi

        if [ "${CONFLICTS}" -gt "0" ]   # Merge conflicts
        then
            echo -en "\001\e[$(retcode)m\002|\001\e[${RED_FG}m\002"
            echo -en "‼"
            echo -en "\001\e[$(retcode)m\002"
        fi

        echo -en "\001\e[$(retcode)m\002)" # End separator
    fi
}

# Set prompt variables
PS1="\[\e[${BLD};\$(retcode)m\]┌("          # Start of first line
PS1="${PS1}\[\e[${PRP_FG}m\]\u@\h"          # username@hostname
PS1="${PS1}\[\e[\$(retcode)m\])─("          # Separator
PS1="${PS1}\[\e[${PRP_FG}m\]\w"             # Directory
PS1="${PS1}\[\e[\$(retcode)m\])"            # Separator
PS1="${PS1}\$(gitparse)"                    # Git information
PS1="${PS1}\n\[\e[${BLD};\$(retcode)m\]└─"  # Start of second line
PS1="${PS1}\\$\[\e[${RST}m\] "              # Second line

# Save the exit code for later use
PROMPT_COMMAND='EXIT_CODE=$?'

# --- Shell extension scripts -------------------------------------------------

# Aliases
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# Generic tab completion support
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# Git tab completion
[ -f ~/.git-completion.sh ] && source ~/.git-completion.sh

# NVM
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# kubectl completion
[ -f /usr/bin/kubectl ] && source <(kubectl completion bash)

# --- Other stuff -------------------------------------------------------------

# Make sure kubectl completion works with the alias
complete -F __start_kubectl k