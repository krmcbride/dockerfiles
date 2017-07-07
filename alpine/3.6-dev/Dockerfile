FROM krmcbride/alpine:3.6-base

RUN apk add --no-cache \
    perl \
    less \
    git \
    openssh-client \
    vim \
    ctags \
    ncurses

COPY diff-* /usr/bin/
ENV VIMRC_VERSION 391f8b5c0680becede604ca84a60ed57f56e42bd
RUN git clone https://github.com/amix/vimrc.git /usr/local/vim_runtime \
    && ( \
        cd /usr/local/vim_runtime \
        && git checkout $VIMRC_VERSION \
        && rm -rf .git \
    )
COPY my_configs.vim /usr/local/vim_runtime/
COPY *.aliases.bash $BASH_IT/aliases/enabled/
COPY *.completion.bash $BASH_IT/completion/enabled/
COPY .bashrc .vimrc .gitconfig /root/
