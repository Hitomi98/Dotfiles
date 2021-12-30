# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
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

# Fix Emacs
export TERM=rxvt 

# My aliases
alias l="ls -la"
alias yum="sudo apt-get install"
alias yumup="sudo apt-get update"
alias chm="chmod a+x *"
alias sclone="rclone rcd --rc-web-gui --rc-user=admin --rc-pass=pass --rc-serve"
alias deez="~/Utilities/Deezloader\ Remix/Deezloader_Remix_4.4.0-x86_64.AppImage &"
alias onenote='~/bin/uploadone' 
alias ripc='~/Utilities/Ripcord/Ripcord-0.4.22-x86_64.AppImage &'
alias rlz='. ~/.zshrc'
alias rmv='trash-put'
alias xstart='xrdb ~/.Xresources'
alias dots='/usr/bin/git --git-dir=$HOME/Git/Dotfiles/ --work-tree=$HOME'
alias dic='sdcv'
alias gitclear='git config --global --unset credential.helper'

# Git Aliases
alias ga="git add ."
alias gp="git push"
alias gr="git fetch --all && git reset --hard origin/master #pull latest from git"
# set gm = git commit followed by message, no quotes!
setopt interactive_comments
preexec(){ _lc=$1; }
alias gm='git commit -m "${_lc#gm }" #'
alias gf='git add . && git commit -m "${_lc#gm }" #'

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

cd ~/
