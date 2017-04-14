export ZSH=/Users/alex/.oh-my-zsh

ZSH_THEME="amuse"

plugins=(brew chruby brew-cask sudo vagrant z )
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $HOME/.environment

zstyle :omz:plugins:chruby auto

