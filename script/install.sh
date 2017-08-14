#! /usr/bin/env bash

pushd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
set -e

EXCLUDES="completion|script|brew"

install_dotfiles () {
  echo 'installing dotfiles'

  dotfiles=$(find . -maxdepth 1 -name "*" -print | sed "s/.\///" | grep "^\w" |
            grep -E -v $EXCLUDES)

  for src in $dotfiles
  do
    target="$DOTFILES_ROOT/$src"
    dst="$HOME/.$src"
    ln -sFfn "$target" "$dst"
    echo "ln -sFfn $target $dst"
  done
}

install_dotfiles

configure_vim () {
  if [ ! -d "$DOTFILES_ROOT/vim/bundle" ]; then
      mkdir -p "$DOTFILES_ROOT/vim/bundle"
  fi

  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
}

configure_vim

popd
