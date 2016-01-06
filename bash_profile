# Settings for all shells

#Environment variables
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export CVS_RSH=ssh
export LESS="-RM"
export NODE_PATH=/usr/local/lib/node_modules

export PATH=$HOME/bin:$HOME/bin/bin:/usr/local/share/npm/bin:/usr/local/share/python:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
source /usr/local/share/chruby/chruby.sh

# Settings for interactive shells

# return if not interactive
[[ $- != *i* ]] && return

# set a default terminal type for deficient systems or weird terminals
tput longname >/dev/null 2>&1 || export TERM=xterm

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

if [[ -z "$dotfiles" ]] || [[ ! -d "$dotfiles" ]] ; then
  #warn "~/.bash_profile should be a link to .bash_profile in the dotfiles repo"
  dotfiles=$HOME/Code/dotfiles
fi

# Finish if we couldn't find our root directory
if [[ -z "$dotfiles" ]] || [[ ! -d "$dotfiles" ]] ; then
  warn "Couldn't find root of dotfiles directory. Exiting .bash_profile early."
  return
fi

export DOTFILES="$dotfiles"



if [ -n "$chruby_defaulted" ] ; then
  warn "chruby version defaulted to $chruby_defaulted: $use_chruby_version"
fi

#running_modern_bash && shopt -s autocd

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

[ -d "$chruby_dir" ] && . $chruby_dir/auto.sh

# Bash
case "$(uname)" in
  *Darwin*) ls_options=-lahG ;;
  *) ls_options=-lah ;;
esac

function onport() {
  (( $# )) || set -- 3000
  lsof -Pni :$*
}

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

#command prompt customization
prompt() {
  local last_status=$?

  local WHITE="\[\033[1;37m\]"
  local GREEN="\[\033[0;32m\]"
  local CYAN="\[\033[0;36m\]"
  local GRAY="\[\033[0;37m\]"
  local BLUE="\[\033[0;34m\]"
  local LIGHT_BLUE="\[\033[1;34m\]"
  local YELLOW="\[\033[1;33m\]"
  local RED="\[\033[1;31m\]"
  local no_color='\[\033[0m\]'

  local time="${YELLOW}\d \@$no_color"
  local whoami="${GREEN}\u@\h$no_color"
  local dir="${CYAN}\w$no_color"

  local branch
  if git rev-parse --git-dir >/dev/null 2>/dev/null ; then
    branch=$(git branch | awk '/^\*/ { print $2 }')
    branch="${branch:+$LIGHT_BLUE$branch}"
  else
    unset branch
  fi

  local driver
  if test -n "$M_DRIVER" ; then
    driver="$LIGHT_BLUE($M_DRIVER)"
  else
    driver="${RED}NO DRIVER"
  fi

  local last_fail
  if test $last_status -ne 0 ; then
    last_fail="=> ${YELLOW}Err: $last_status${no_color}\n"
  else
    unset last_fail
  fi

  PS1="\n$time $dir($branch$no_color)\$ " #\n$last_fail$no_color\$ "
}

# set the tab title to the current directory
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"; prompt';
fi

# retain $PROMPT_DIRTRIM directory components when the prompt is too long
PROMPT_DIRTRIM=3

# Load completion files from $dotfiles/completion/{function}.bash
for script in $( ls "$dotfiles/completion/" ) ; do
  . "$dotfiles/completion/$script" > /dev/null 2>&1
done


source "$HOME/.aliases"
