#!/bin/bash
# @author: zhaoyk2010@163.com
# This is a library of Bash shell for echo with colors.

source $MYSHELLIB/libui-sh/libui-colors.sh;

function echoc() {
    declare ECHO='echo -e';
    if [ "$1" == '-n' ]; then
        ECHO="$ECHO -n";
        shift;
    fi
    declare color=$(eval echo "\$$1");
    if [ "$color" ]; then
        shift;
    fi
    if [ "$color" == '$' ]; then
        color='';
    fi
    $ECHO "$color${@}$Color_Off";
}


