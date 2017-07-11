export TERM="${TERM_OVERRIDE-xterm-256color}"
export LANG=en_US.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="~/.ssh/rsa_id"
export ZSH=/usr/local/oh-my-zsh

ZSH_THEME="${ZSH_THEME-robbyrussell}"
DISABLE_AUTO_UPDATE="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

