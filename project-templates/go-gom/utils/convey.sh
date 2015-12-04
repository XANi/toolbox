#!/bin/bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "$GIT_ROOT"

if [ -e `which xdg-open` ] ; then
    bash -c 'sleep 3 ; xdg-open http://127.0.0.1:3002' &
elif [ -e `which x-www-browser` ] ; then
    bash -c 'sleep 3 ; x-www-browser http://127.0.0.1:3002' &
else
    bash -c 'sleep 3 ; firefox http://127.0.0.1:3002' &
fi
if [ -e Gomfile ]; then
    gom exec goconvey -port 3002
else
    goconvey -port 3002
fi
