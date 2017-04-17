# Make $path array ignore non-unique elements
typeset -U path

PLATFORM=`uname -s`

export MAVEN_OPTS='-Xms256m -Xmx645m -XX:PermSize=64m -XX:MaxPermSize=256m'
export JAVA_OPTS='-server -Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -XX:NewSize=192m -XX:MaxNewSize=384m -Djava.awt.headless=true -Dhttp.agent=Sakai -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Dsun.lang.ClassLoader.allowArraySyntax=true'

export HTML_TIDY=~/.htmltidy.conf

# Platform specific config
if [[ $PLATFORM = 'Darwin' ]]; then
  manpath=(/opt/local/share/man $manpath)

  export GOPATH=~/Library/Go
elif [[ $PLATFORM = 'Linux' ]]; then
  whence pacman-color > /dev/null && alias -g pacman=pacman-color

  export GOPATH=~/.go
else
  # Exclude some gems from being installed on non-Mac systems
  BUNDLE_WITHOUT=darwin_only
fi

if [[ -z ${SSH_CONNECTION} ]]; then
  # Don't clobber forwarded SSH agent stuff
  local GPG_ENV=~/.gnupg/gpg-agent.env
  if [[ -s ${GPG_ENV} ]]; then
    # GnuPG version 2.0
    . ${GPG_ENV} > /dev/null
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
  else
    # GnuPG version 2.1+
    # if gpgconf --list-dirs | grep agent-ssh-socket > /dev/null; then
    case $(gpgconf --list-dirs) in
      *agent-ssh-socket*)
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) ;;
      *)
        export SSH_AUTH_SOCK=~/.gnupg/S.gpg-agent.ssh ;;
    esac
  fi
  export GPG_TTY=$(tty)
  echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1
fi

# Source local rvm config
if [[ -s "$HOME/.rvmrc" ]]; then
  source "$HOME/.rvmrc"
fi

# Try some common options for rvm location
if [[ -z "$rvm_path" ]]; then
  if [[ -s "/usr/local/rvm/scripts/rvm" ]]; then
    rvm_path=/usr/local/rvm
  elif [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    rvm_path=$HOME/.rvm
  fi
fi

TEXMFHOME=~/.texmf:~/Dropbox/TeX
export TEXMFHOME

if [[ -n "$EMACS" ]]; then # If we're running a terminal inside emacs
  export EDITOR=$(which emacsclient)
else
  export EDITOR="$(which emacsclient) -t"
  export ALTERNATE_EDITOR=$(which vim)
fi

if [[ -s "$HOME/.zshenv.local" ]]; then
  source "$HOME/.zshenv.local"
fi

# Create $GOPATH if it doesn't exist
mkdir -p $GOPATH

if ! setopt | grep login >/dev/null; then
  source ~/.zshenv.path
fi

# Local Variables:
# mode: sh
# End:
