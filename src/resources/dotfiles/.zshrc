export TERM="${TERM_OVERRIDE-xterm-256color}"
export EDITOR="${EDITOR-vim}"
export SSH_KEY_PATH="${SSH_KEY_PATH-~/.ssh/id_rsa}"
export ZSH=/usr/local/oh-my-zsh

ZSH_THEME="${ZSH_THEME-robbyrussell}"
DISABLE_AUTO_UPDATE="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

