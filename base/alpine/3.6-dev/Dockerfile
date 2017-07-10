# Note: this file is generated, do not edit directly

FROM krmcbride/alpine:3.6-base
LABEL maintainer="krmcbride.io@gmail.com"

RUN apk add --no-cache \
    perl \
    less \
    git \
    openssh-client \
    vim \
    ctags \
    ncurses \
    zsh \
  && git clone https://github.com/amix/vimrc.git /usr/local/vim_runtime \
  && ( \
    cd /usr/local/vim_runtime \
    && git checkout 391f8b5c0680becede604ca84a60ed57f56e42bd \
    && rm -rf .git \
  ) \
  && git clone https://github.com/robbyrussell/oh-my-zsh.git /usr/local/oh-my-zsh \
  && ( \
    cd /usr/local/oh-my-zsh \
    && git checkout d848c94804918138375041a9f800f401bec12068 \
    && rm -rf .git \
  )

COPY common/diff-* /usr/bin/
COPY common/my_configs.vim /usr/local/vim_runtime/
COPY common/*.aliases.bash /usr/local/bash-it/aliases/enabled/
COPY common/*.completion.bash /usr/local/bash-it/completion/enabled/
COPY common/*.plugin.bash /usr/local/bash-it/plugins/enabled/
COPY common/*aliases.zsh /usr/local/oh-my-zsh/custom/
COPY common/gitconfig /etc/
COPY common/dotfiles/.vimrc common/dotfiles/.zshrc /root/

CMD ["/bin/zsh"]
