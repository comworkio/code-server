#!/usr/bin/env bash

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -la'
alias cls='clear'
alias tailf='tail -F'
alias docker='sudo docker'
alias docker-compose='sudo docker-compose'
alias k3d='sudo k3d'

CYAN="\033[1;36m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
PURPLE="\033[1;35m"
WHITE="\033[1;37m"
RESET="\033[0;37m"

function ggit () {
  if [[ -d .git ]]; then
    git $@ 2> /dev/null
  else
    echo ""
  fi
}

function parse_git_dirty () {
 [[ $(ggit status | tail -n1) != "nothing to commit (working directory clean)" ]] && echo " *"
}

function parse_git_branch () {
 ggit branch --no-color | sed -e '/^[^*]/d' -e "s/^* \(.*\)/\1$(parse_git_dirty)/"
}

export PS1="\[${YELLOW}\]\u\[$WHITE\]@\[$CYAN\]\h\[$WHITE\]\$([[ -n \$(ggit branch) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch) \[$GREEN\]\w\[$WHITE\] $(ggit describe)$ "
