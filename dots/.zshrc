# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt beep extendedglob
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# User configuration
# ---
export EDITOR="vim"
export TERM="screen-256color"
. /lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh

export PATH="$PATH:$HOME/.gem/ruby/2.2.0/bin"

# Bindings
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[OC" forward-word
bindkey "^[[1;5C" forward-word
bindkey "^[OD" backward-word
bindkey "^[[1;5D" backward-word

bindkey "^J" down-line-or-history
bindkey "^K" up-line-or-history

# Aliases
alias ls='ls --color=always'
alias vol='pulseaudio-ctl set'
alias mute='pulseaudio-ctl mute'
alias bl='xbacklight -set'
alias fal='cd $HOME/Documents/School/F15/$1'
alias bio='cd $HOME/Documents/School/F15/BIO/'
alias cop='chromium http://www.cs.ucf.edu/courses/cop3223/fall2015/section3/'
alias prog='cd $HOME/Documents/School/F15/COP/'
alias pos='cd $HOME/Documents/School/F15/POS/'
alias sta='cd $HOME/Documents/School/F15/STA/'
alias powerline-config='cd /usr/lib/python3.4/site-packages/powerline/config_files'
alias clock='date +%c'
