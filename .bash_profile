PS1="${YELLOW}\u@\h ${RESET}\W ${GREEN}\$(__git_ps1 '(%s) ')${RESET}\$ "

for f in ~/scripts; do source $f; done

source ~/.colors
