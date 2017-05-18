#!/bin/bash

#adapted from http://eradman.com/posts/ut-shell-scripts.html

typeset -i tests_run=0

function try { this="$1"; }

trap 'printf "$0: exit code $? on line $LINENO\nFAIL: $this\n"; exit 1' ERR

#check returned value is what is expected
function assert {
        let tests_run+=1
        [ "$1" = "$2" ] && { echo -n "."; return; }
        printf "\nFAIL: $this\n'$1' != '$2'\n"; exit 1
}

#check the script fails as expected
function assert_fail {
        let tests_run+=1
        [ "${1//$2}" != "${1}" ] && { echo -n "."; return; }
        printf "\nFAIL: $this\n '$1' exit code = 0\n"; exit 1
}

#check we are in an empty directory to avoid deleting files
if [ "`ls`" != "" ]
  then
    echo "ERROR: Run this script in an empty directory!!!!!"
    exit 1;
fi

#workaround for success
try "number of labels has to be the same as conditions provided 1"
assert_fail "`samples1=filenames samples2=filenames2 samples4=filenames3 labels=correct,no,labels ../wrapper.sh 2>&1 >/dev/null`" "chmod: cannot access 'launch.sh"

try "number of labels has to be the same as conditions provided 2"
assert_fail "`samples1=filenames samples2=filenames labels=too,many,labels,here ../wrapper.sh 2>&1 >/dev/null`" "ERROR: you provided a different number of labels and condition"

echo; echo "PASS: $tests_run tests run"
