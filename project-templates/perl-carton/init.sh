#!/bin/bash
DIR=$( cd "$( dirname "BASH_SOURCE[0]" )" && pwd )
cd $DIR
if which carton ; then
    CARTON=$(which carton)
elif [ -x '/usr/local/bin/carton' ] ; then
    CARTON='/usr/local/bin/carton'
else
    echo "Please install carton!"
    exit 1
fi

if [ ! -e cpanfile.snapshot ] ; then
    $CARTON install
fi
if [ ! -e Makefile ] ; then
    $CARTON exec perl Makefile.PL
fi
