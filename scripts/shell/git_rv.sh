#!/usr/bin/env bash

export GIT_REPO="$(git remote -v |grep 'fetch' |awk '{print $2}')"
