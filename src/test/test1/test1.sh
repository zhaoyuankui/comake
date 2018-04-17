#!/bin/bash

#adkfasdf
   ## desc
#   source 

unset MYSHELLIB;

########### Add MYSHELLIB env. Comake auto generated. ###########
[ ! "$MYSHELLIB" ] && _PWD="$PWD" && cd $(dirname "$0") && while [ ! -d myshellib ]; do if [ "`pwd`" == "/" ]; then break; fi; cd ..; done && export MYSHELLIB="`pwd`/myshellib" && cd $_PWD;
#############################################

   source    $MYSHELLIB/echoc.sh;
   echoc Red aaa;
