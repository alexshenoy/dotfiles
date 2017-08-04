export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="amuse"

plugins=(brew brew-cask sudo vagrant z )
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh_functions
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $HOME/.environment
if [[ -f "/usr/local/share/chruby/chruby.sh" ]]; then
    source "/usr/local/share/chruby/chruby.sh"
    source "/usr/local/share/chruby/auto.sh"
fi


# OPAM configuration
. /Users/alex/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true



# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh