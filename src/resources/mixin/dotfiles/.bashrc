#!/usr/bin/env bash

export BASH_IT="${BASH_IT-/usr/local/bash-it}"
export BASH_IT_THEME="${BASH_IT_THEME-atomic}"
export SCM_CHECK="${SCM_CHECK-true}"
export THEME_BATTERY_PERCENTAGE_CHECK="${THEME_BATTERY_PERCENTAGE_CHECK-false}"
export THEME_SHOW_BATTERY="${THEME_SHOW_BATTERY-false}"
export TERM="${TERM_OVERRIDE-xterm-256color}"

source $BASH_IT/bash_it.sh
