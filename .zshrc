# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
LSCOLORS=ExFxCxDxBxegedabagacad

LANG="en_US.UTF-8"
export LC_CTYPE="UTF-8"
export LC_ALL=$LANG
export PKG_CONFIG_PATH=/usr/local/Library/ENV/pkgconfig/10.9
export EDITOR=nvim

export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH=/usr/local/bin:${PATH}
export PATH=/usr/local/sbin:${PATH}
export PATH=${PATH}:/usr/local/go/bin
export PATH=${PATH}:/Users/maks/Library/Python/3.8/bin
export PATH=/usr/local/opt/php@8.2/bin:${PATH}
export PATH=${PATH}:/Users/maks/bin
export PATH=/opt/homebrew/bin:${PATH}

export DOCKER_DEFAULT_PLATFORM=linux/amd64
#export DOCKER_BUILDKIT=0

eval "$(zoxide init zsh)"

export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc

setopt extended_glob prompt_subst
autoload colors zsh/terminfo
# Use modern completion system
autoload -Uz compinit
compinit

#compdef -d git

__git_files () {
    _wanted files expl 'local files' _files
}

bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _files _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

alias ls="ls -G"
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -lah"
alias mv="mv -i"
alias rm="rm -r"
alias cls="clear"
alias upmem="ps aux | sort -k 5"
alias df="df -h"
alias dusort="du -sm * | sort -rn"
alias weather="curl http://wttr\.in/zhytomyr"
alias show-colors='for code ({000..255}) { print -nP -- "$code: %F{$code}%K{$code}Test%k%f " ; (( code % 8 && code < 255 )) || printf "\n"}'
alias v="nvim"
alias myip="curl ifconfig.co/json"
alias ping1="ping 1.1.1.1"

source ~/.zsh/.ssh_aliases

alias gst="git status"
alias gl="git pull"
alias glr="git pull --rebase"
alias gp="git push"
alias gpg="git push origin HEAD:refs/for/master"
alias gd="git diff"
alias gau="git add --update"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gb="git branch"
alias gba="git branch -a"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcot="git checkout -t"
alias gcotb="git checkout --track -b"
alias glog="git log"
alias glogp="git log --pretty=format:'%h %s' --graph"
alias glogstat="git log --stat -p"


alias gserve="git pull && npm run build && npm run serve"

alias sd="cd \$(fd --type d -I . ~/Projects/ | fzf)"


function precmd {
     # Terminal width = width - 1 (for lineup)
     local TERMWIDTH
     ((TERMWIDTH=${COLUMNS} - 1))

     # Truncate long paths
     PR_FILLBAR=""
     PR_PWDLEN=""
     local PROMPTSIZE="${#${(%):---(%n@%m:%l)---()--}}"
     local PWDSIZE="${#${(%):-%~}}"
     if [[ "${PROMPTSIZE} + ${PWDSIZE}" -gt ${TERMWIDTH} ]]; then
     ((PR_PWDLEN=${TERMWIDTH} - ${PROMPTSIZE}))
     else
         PR_FILLBAR="\${(l.((${TERMWIDTH} - (${PROMPTSIZE} + ${PWDSIZE})))..${PR_HBAR}.)}"
     fi
 }

 function preexec () {
     # Screen window titles as currently running programs
     if [[ "${TERM}" == "screen-256color" ]]; then
         local CMD="${1[(wr)^(*=*|sudo|-*)]}"
         echo -n "\ek$CMD\e\\"
     fi
 }

function setprompt () {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_"${color}"="%{${terminfo[bold]}$fg[${(L)color}]%}"
    eval PR_LIGHT_"${color}"="%{$fg[${(L)color}]%}"
    done
    PR_NO_COLOUR="%{${terminfo[sgr0]}%}"

    # Try to use extended characters to look nicer
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{${terminfo[enacs]}%}"
    PR_SHIFT_IN="%{${terminfo[smacs]}%}"
    PR_SHIFT_OUT="%{${terminfo[rmacs]}%}"
    PR_HBAR="${altchar[q]:--}"
    PR_ULCORNER="${altchar[l]:--}"
    PR_LLCORNER="${altchar[m]:--}"
    PR_LRCORNER="${altchar[j]:--}"
    PR_URCORNER="${altchar[k]:--}"

    # Terminal prompt settings
    case "${TERM}" in
        dumb) # Simple prompt for dumb terminals
            unsetopt zle
            PROMPT='%n@%m:%~%% '
            ;;
        linux) # Simple prompt with Zenburn colors for the console
            echo -en "\e]P01e2320" # zenburn black (normal black)
            echo -en "\e]P8709080" # bright-black  (darkgrey)
            echo -en "\e]P1705050" # red           (darkred)
            echo -en "\e]P9dca3a3" # bright-red    (red)
            echo -en "\e]P260b48a" # green         (darkgreen)
            echo -en "\e]PAc3bf9f" # bright-green  (green)
            echo -en "\e]P3dfaf8f" # yellow        (brown)
            echo -en "\e]PBf0dfaf" # bright-yellow (yellow)
            echo -en "\e]P4506070" # blue          (darkblue)
            echo -en "\e]PC94bff3" # bright-blue   (blue)
            echo -en "\e]P5dc8cc3" # purple        (darkmagenta)
            echo -en "\e]PDec93d3" # bright-purple (magenta)
            echo -en "\e]P68cd0d3" # cyan          (darkcyan)
            echo -en "\e]PE93e0e3" # bright-cyan   (cyan)
            echo -en "\e]P7dcdccc" # white         (lightgrey)
            echo -en "\e]PFffffff" # bright-white  (white)
            PROMPT='$PR_MAGENTA%n@%m$PR_WHITE:$PR_YELLOW%l$PR_WHITE:$PR_RED%~$PR_YELLOW%%$PR_NO_COLOUR '
            ;;
        *)  # Main prompt
            PROMPT='$PR_SET_CHARSET$PR_MAGENTA$PR_SHIFT_IN$PR_ULCORNER$PR_MAGENTA$PR_HBAR\
$PR_SHIFT_OUT($PR_MAGENTA%n$PR_MAGENTA@%m$PR_WHITE:$PR_YELLOW%l$PR_MAGENTA)\
$PR_SHIFT_IN$PR_HBAR$PR_MAGENTA$PR_HBAR${(e)PR_FILLBAR}$PR_MAGENTA$PR_HBAR$PR_SHIFT_OUT(\
$PR_RED%$PR_PWDLEN<...<%~%<<$PR_MAGENTA)$PR_SHIFT_IN$PR_HBAR$PR_MAGENTA$PR_URCORNER$PR_SHIFT_OUT\

$PR_MAGENTA$PR_SHIFT_IN$PR_LLCORNER$PR_MAGENTA$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_RED%?$PR_WHITE:)%(!.$PR_RED.$PR_YELLOW)%#$PR_MAGENTA)$PR_NO_COLOUR '

            RPROMPT=' $PR_MAGENTA$PR_SHIFT_IN$PR_HBAR$PR_MAGENTA$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'
            ;;
    esac
}

# Prompt init
setprompt


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#If you need to have this software first in your PATH run:
#  echo 'export PATH="/usr/local/opt/icu4c/bin:$PATH"' >> ~/.zshrc
#  echo 'export PATH="/usr/local/opt/icu4c/sbin:$PATH"' >> ~/.zshrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
