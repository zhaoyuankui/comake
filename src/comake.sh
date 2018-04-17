#!/bin/bash

source $MYSHELLIB/env.sh;
source $MYSHELLIB/utils.sh;
source $MYSHELLIB/log.sh;
source $MYSHELLIB/libui-sh/libui.sh;

declare COMAKE_SHELL_COMMENTS='Add MYSHELLIB env. Comake auto generated.';

function show_help() {
    if [ "$1" ]; then
        exit "$1";
    fi
}

function check_params() {
    :
}

function comake_python() {
    :
}

function parse_new_dependencies() {
    declare -a new_dependencies=($1);
    if [ ${#new_dependencies[@]} -le 0 ]; then
        return;
    fi
    dependencies=(${dependencies[@]} ${new_dependencies[@]});
    declare -a dependency_files=($(eval echo "${new_dependencies[@]}"));
    declare -a newer_dependencies=(`grep -oE '^\s*source\s\s*\\$MYSHELLIB[^ #;]*|^\s*\.\s\s*\\$MYSHELLIB[^ #;]*' "${dependency_files[@]}" | awk '{print $NF}'`);
    new_dependencies=();
    for dependency in ${newer_dependencies[@]}; do
        if check_is_in "$dependency" "${dependencies[@]}"; then
            continue;
        fi
        new_dependencies=(${new_dependencies[@]} $dependency);
    done
    parse_new_dependencies "${new_dependencies[*]}";
}

function parse_dependencies() {
    declare -a dependencies=();
    declare -a new_dependencies=(`grep -oE '^\s*source\s\s*\\$MYSHELLIB[^ #;]*|^\s*\.\s\s*\\$MYSHELLIB[^ #;]*' "${@}" | awk '{print $NF}'`);
    parse_new_dependencies "${new_dependencies[*]}";
    echo ${dependencies[@]};
}

function get_location() {
    declare -i cnt=0;
    while read line; do
        cnt=$((cnt+1));
        # skip comments.
        if [ "`echo $line | grep -E '^\s*#'`" ]; then
            continue;
        fi
        # skip empty lines.
        if [ ! "`echo $line`" ]; then
            continue;
        fi
        break;
    done < "$1";
    echo $cnt;
}

function add_myshellib_env() {
    for file in "${@}"; do
        if [ ! "`grep -oE '^\s*source\s\s*\\$MYSHELLIB[^ #;]*|^\s*\.\s\s*\\$MYSHELLIB[^ #;]*' $file`" ]; then
            continue;
        fi
        if [ "`grep "$COMAKE_SHELL_COMMENTS" $file`" ]; then
            continue;
        fi
        declare -i line_num=`get_location "$file"`;
        declare sed_script='i \\n########### '$COMAKE_SHELL_COMMENTS' ###########\n[ ! "$MYSHELLIB" ] && _PWD="$PWD" && cd $(dirname "$0") && while [ ! -d myshellib ]; do if [ "`pwd`" == "/" ]; then break; fi; cd ..; done && export MYSHELLIB="`pwd`/myshellib" && cd $_PWD;\n#############################################\n'; 
        sed -i "$line_num$sed_script" "$file";
    done
}

function comake_shell() {
    declare -a dependencies=(`parse_dependencies "${@}"`);
    if [ ${#dependencies[@]} -eq 0 ]; then
        return;
    fi
    for dependency in "${dependencies[@]}"; do
        declare -a install_path="`echo $dependency | sed -n 's/$MYSHELLIB/myshellib/p'`";
        if [ -e "$install_path" ]; then
            continue;
        fi
        mkdir -p "${install_path%/*}";
        install -m644 "$MYSHELLIB/${dependency#*/}" "$install_path" || die \
            "Add dependency '${dependency}' failed.";
    done
    add_myshellib_env "${@}";
}

function comake() {
    if [ ! -f '.comake' ]; then
        die "No '.comake' found.";
    fi
    declare -i c=0;
    declare -a shells=();
    declare -a pythons=();
    while read file; do
        c=$((c+1));
        not_empty "$file" || continue;
        if [ ! -f "$file" ]; then
            warn "File '$file' at line $c in .comake not found.";
            continue;
        fi
        if [[ "$file" == *.sh ]]; then
            shells[$c]=$file;
        elif [[ "$file" == *.py ]]; then
            pythons[$c]=$file;
        else
            warn "File '$file' at line $c in .comake not supported.";
            continue;
        fi
    done < .comake;
    if [ ${#shells[@]} -gt 0 ]; then
        comake_shell "${shells[@]}";
    fi
    if [ ${#pythons[@]} -gt 0 ]; then
        comake_python "${pythons[@]}";
    fi
}

function run() {
    check_params "${@}" || show_help 1;
    if [ -f Makefile ]; then
        make || die 'Make failed.';
        [ -d output ] && cd output;
    fi
    comake;
}

run "${@}";
