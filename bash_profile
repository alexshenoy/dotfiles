# Settings for all shells

#Environment variables
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export CVS_RSH=ssh
export LESS="-RM"
export NODE_PATH=/usr/local/lib/node_modules

export PATH=$HOME/bin:$HOME/bin/bin:/usr/local/share/npm/bin:/usr/local/share/python:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$PATH:$HOME/toolchain/gcc-arm-none-eabi-4_9-2015q1/bin

if [ -f /usr/local/share/chruby/chruby.sh ] ; then
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
fi

# Settings for interactive shells

# return if not interactive
[[ $- != *i* ]] && return

# set a default terminal type for deficient systems or weird terminals
#tput longname >/dev/null 2>&1 || export TERM=xterm

warn() {
  tput setaf 1 >&2
  printf '%s\n' "$*"
  tput sgr0 >&2
}

## Set up $dotfiles directory
# returns true if the program is installed
installed() {
  hash "$1" >/dev/null 2>&1
}

# OSX `readlink` doesn't support the `-f` option (-f = follow components to make full path)
# If `greadlink` is installed, use it
# Otherwise, use the dir and basename provided to construct a sufficient stand-in
relative_readlink() {
  local dir="$1" base="$2"
  if installed greadlink ; then
    dirname "$(greadlink -f "$dir/$base")"
  elif pushd "$dir" >/dev/null 2>&1 ; then
    local link="$(readlink "$base")"
    case "$link" in
      /*) dirname "$link" ;;
      *) pushd "$(dirname "$link")" >/dev/null 2>&1 ; pwd -P ; popd >/dev/null ;;
    esac
    popd >/dev/null
  fi
}

if [[ -L "$HOME/.bash_profile" ]] ; then
  dotfiles="$(relative_readlink "$HOME" .bash_profile)"
fi

# Finish if we couldn't find our root directory
if [[ -z "$dotfiles" ]] || [[ ! -d "$dotfiles" ]] ; then
  warn "Couldn't find root of dotfiles directory. Exiting .bash_profile early."
  return
fi

export DOTFILES="$dotfiles"

# History settings
# ignoreboth=ignoredups:ignorespace
# ignoredups = ignore duplicate commands in history
# ignorespace = ignore commands that start with space
HISTCONTROL=ignoreboth

# Save (effectively) all commands ever
HISTSIZE=10000000
HISTFILESIZE=10000000

# only append the history at the end (shouldn't actually be needed - histappend)
shopt -s histappend

## only binds the given termcap entr(y|ies) to a widget if the terminal supports it
termcap_bind() {
  local widget=$1 key termcap
  shift
  for termcap ; do
    key="$(tput $termcap)"
    [ -n "$key" ] && bind "\"$key\": $widget"
  done
}

# Search history
termcap_bind history-search-backward cuu1 kcuu1
termcap_bind history-search-forward cud1 kcud1

# Simulate Zsh's preexec hook (see: http://superuser.com/a/175802/73015 )
# (This performs the histappend at a better time)
simulate_preexec() {
  [ -n "$COMP_LINE" ] || # skip if doing completion
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] || # skip if generating prompt
    history -a
}
trap simulate_preexec DEBUG

if [ -L ~/.prompt  ] ; then
    . ~/.prompt
fi

# Load completion files from $dotfiles/completion/{function}.bash
for script in $( ls "$dotfiles/completion/" ) ; do
  . "$dotfiles/completion/$script" > /dev/null 2>&1
done


source "$HOME/.aliases"
