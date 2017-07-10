
# hub
alias git=hub

# shell
alias c='clear'
alias l='ls -hl'
alias all='l -A'
alias ll='l -A'

# Docker
alias docker_stats='docker stats $(docker ps|grep -v "NAMES"|awk '\''{ print $NF }'\''|tr "\n" " ")'
alias docker_syslog='syslog -w boot -k Sender Docker'
alias random_port="docker run -it --rm krmcbride/ubuntu:14.04 shuf -i 32768-61000 -n 1"
alias lo0_alias='sudo ifconfig lo0 alias 172.16.123.1'
#alias docker_xhyve='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias docker_xhyve='docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh'

# Git
alias g='git'
alias ga='git add'
alias gall='git add -A'
alias gd='git diff'
alias gl='git log -10'
alias gs='git status'
alias gss='git status -s'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -v -m'
alias gg="git log --graph --pretty=format:'%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
# From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
# Show commits since last pull
alias gnew="git log HEAD@{1}..HEAD@{0}"
# Add uncommitted and unstaged changes to the last commit
alias gcaa="git commit -a --amend -C HEAD"


alias java-repl='java -jar ~/Sites/GitHub/albertlatacz/java-repl/build/libs/javarepl-dev.jar'

