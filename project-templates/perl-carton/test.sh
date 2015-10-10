#!/bin/bash

# run "normal" tests via carton
# generate a bunch of extras (coverage, junit test results etc) when run from jenkins

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

./init.sh
rm -rf cover_db

# standalone mode
if [ "z$BUILD_NUMBER" = "z" ] ; then
    $CARTON exec -- prove -l -v --color -o
else
    make
    export HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore_re,^local
    $CARTON exec -- prove --timer --formatter=TAP::Formatter::JUnit -l > test_results.xml 2>test_errors.log ; date >> test_errors.log
    echo "results in test_results.xml, errors in test_errors.log"

    $CARTON exec -- cover -report clover
    $CARTON exec -- cover -report html
    cat test_errors.log  |grep -i -P  "syntax error" -q -v || exit 1
fi
