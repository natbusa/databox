#!/bin/bash
set +e

##### Color table #####
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
# ref: https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
if [ -t 1 ]; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
        termcols="$(tput cols)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"

        bold="$(tput bold)"
        italic="$(tput sitm)"
        underline="$(tput smul)"
        # strikethrough="\e[9m"

        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi
