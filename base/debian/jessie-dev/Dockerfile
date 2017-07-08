FROM krmcbride/debian:jessie-base

RUN apt-get update \
  && apt-get remove -y --purge \
    vim.tiny \
  && apt-get install -y --no-install-recommends \
    perl \
    less \
    git \
    openssh-client \
    vim \
    ctags \
  && rm -rf /var/lib/apt/lists/ \
  && git clone https://github.com/amix/vimrc.git /usr/local/vim_runtime \
    && ( \
        cd /usr/local/vim_runtime \
        && git checkout 391f8b5c0680becede604ca84a60ed57f56e42bd \
        && rm -rf .git \
    )

COPY common/diff-* /usr/bin/
COPY common/my_configs.vim /usr/local/vim_runtime/
COPY common/*.aliases.bash $BASH_IT/aliases/enabled/
COPY common/*.completion.bash $BASH_IT/completion/enabled/
COPY common/*.plugin.bash $BASH_IT/plugins/enabled/
COPY common/gitconfig /etc/
COPY common/dotfiles/.vimrc /root/
