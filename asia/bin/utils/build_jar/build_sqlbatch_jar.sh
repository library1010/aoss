#!/bin/sh

CMDNAME=`basename $0`

buildJar() {
    local branch_name=$1
    local profile=$2

    cd /data/shell/build
    checkError $? "/data/shell/build does not exist."
    ./build_sqlbatch.sh $branch_name $profile
    checkError $? "Build failed."
    ls -la /data/src/speeda-sqlbatch/speeda-sqlbatch/target
    checkError $? "Build folder does not exist."
}

backupJar() {
    echo "Not implemented yet"
}

checkError() {
    local check_arg=$1
    local fail_message=$2

    if [ "$check_arg" -ne "0" ]; then
        echo "$fail_message"
        exit 1
    fi

    return $check_arg
}

transferJar() {
    local branch_name=$1
    local server_name=$2
    cd /data/src/speeda-sqlbatch/speeda-sqlbatch/target
    scp speeda-sqlbatch-jar-with-dependencies.jar \
	$server_name:/data/java/speeda-sqlbatch-jar-with-dependencies.jar.${branch_name//\//_}
}

yesNoSelection() {
    local message=$1
    
    echo $message
    select yn in "Yes" "No"; do
	case $yn in
            Yes ) break;;
            No ) exit;;
	esac
    done
}

doMain() {
    local branch_name="$1"

    if [ -z $branch_name ]; then
	branch_name=default
    fi
    
    buildJar $branch_name testinghanoi
    backupJar
    yesNoSelection "Do you want to continue to transfer file to dev-hanoi-batch01?"
    transferJar $branch_name dev-hanoi-batch01
    yesNoSelection "Do you want to continue to transfer file to dev-hanoi-batch02?"
    transferJar $branch_name dev-hanoi-batch02
}

doMain $1
exit 0
