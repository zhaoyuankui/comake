#!/bin/bash

# This is a inner test.


########### Add MYSHELLIB env. Comake auto generated. ###########
[ ! "$MYSHELLIB" ] && _PWD="$PWD" && cd $(dirname "$0") && while [ ! -d myshellib ]; do if [ "`pwd`" == "/" ]; then break; fi; cd ..; done && export MYSHELLIB="`pwd`/myshellib" && cd $_PWD;
#############################################

. $MYSHELLIB/libui-sh/libui.sh;
declare -a aaa=(1 2 3 4);
declare bbb=5;
check_is_in 5 ${aaa[@]} || echo 'Not in';
