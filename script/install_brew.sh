#! /bin/bash -ex

install_brew () {
  echo 'installing homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew tap Homebrew/bundle
}

pushd brew
 install_brew
 brew bundle
popd
