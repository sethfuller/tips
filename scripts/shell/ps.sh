#!/usr/bin/env bash

ps -ef |& egrep -v 'grep|ps.sh' |& egrep 'PID|'$1
