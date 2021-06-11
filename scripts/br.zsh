#!/usr/bin/env zsh

    zparseopts -D -E n::=infos i::=installs -upd=upd -upg=upg
    print "infos $infos[@] Count: ${#infos}"
    print "installs $installs[@] Count: ${#installs}"
    cmd=()
set -x
    if [ "${#infos}" -gt 0 ]
    then
	infos=("${(@)infos:#-n}")
	cmd=("info" $infos[@])
    elif [ "${#installs}" -gt 0 ]
    then
	installs=("${(@)installs:#-n}")
	cmd=("install" $installs[@])
#	cmd="install $installs[@]"
    elif [ "${#upd}" -gt 0 ]
    then

	cmd=("update")
    elif [ "${#upg}" -gt 0 ]
    then
	cmd=("upgrade")
    else
	cmd=($*)
    fi
    set -x
    print "cmd $cmd"
    brew $cmd
    set +x
