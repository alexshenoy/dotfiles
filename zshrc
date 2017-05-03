export ZSH=/Users/alex/.oh-my-zsh

ZSH_THEME="amuse"

plugins=(brew chruby brew-cask sudo vagrant z )
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh_functions
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $HOME/.environment

zstyle :omz:plugins:chruby auto

# OPAM configuration
. /Users/alex/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


