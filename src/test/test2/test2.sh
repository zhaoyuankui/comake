#!/bin/bash

#adkfasdf
   ## desc
#   source 


unset MYSHELLIB;

########### Add MYSHELLIB env. Comake auto generated. ###########
[ ! "$MYSHELLIB" ] && _PWD="$PWD" && cd $(dirname "$0") && while [ ! -d myshellib ]; do if [ "`pwd`" == "/" ]; then break; fi; cd ..; done && export MYSHELLIB="`pwd`/myshellib" && cd $_PWD;
#############################################

echo $MYSHELLIB;

   source    $MYSHELLIB/echoc.sh;

   echoc Red aaa;
   sh ./inner_test2/inner_test2.sh;
   sh ./test2_2.sh;
