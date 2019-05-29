export TERM="${TERM_OVERRIDE-xterm-256color}"
export EDITOR="${EDITOR-vim}"
export SSH_KEY_PATH="${SSH_KEY_PATH-~/.ssh/id_rsa}"
export ZSH=/usr/local/oh-my-zsh

ZSH_THEME="${ZSH_THEME-spaceship-prompt/spaceship}"
DISABLE_AUTO_UPDATE="true"
plugins=(git docker docker-compose kubectl)

# https://github.com/moby/moby/commit/402caa94d23ea3ad47f814fc1414a93c5c8e7e58
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

source $ZSH/oh-my-zsh.sh

