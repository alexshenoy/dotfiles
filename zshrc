export ZSH=/Users/alex/.oh-my-zsh

ZSH_THEME="amuse"

plugins=(git brew chruby brew-cask sudo vagrant z command-not-found)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $HOME/.environment

if [ -f /usr/local/share/chruby/chruby.sh ] ; then
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
fi
