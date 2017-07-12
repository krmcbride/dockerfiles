
# shell
alias c='clear'
alias l='ls -hl'
alias all='l -A'
alias ll='l -A'

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

# misc
alias todo='todo.sh'
