#!/bin/sh

CMDNAME=`basename $0`

checkError() {
    local check_arg=$1
    local fail_message=$2

    if [ "$check_arg" -ne "0" ]; then
        echo "$fail_message"
        exit 1
    fi

    return $check_arg
}

# This function does the following:
# 1. Set file encoding (read mode) to UTF-8
# 2. Set file encoding (write mode) to UTF-8
# 3. Set file ending to unix type
# 4. Get rid of BOM 
normalizeAsiagateDataFile() {
    local filename=$1
    vim -c "set encoding=utf8" \
	-c "set fileencoding=utf8" \
	-c "set fileformat=unix" \
	-c "set nobomb" \
	-c "wq" \
	$filename
    checkError $? "Converted using vim's failed."
}

processOneFile() {
    local filename=$1
    echo "File information before converting:"
    file $filename
    normalizeAsiagateDataFile $filename
    # yesNoSelection "Wanna get rid of the first line?" && getRidOfFirstLine $filename
    getRidOfFirstLine $filename
    echo "Got rid of the first line"
    echo "Converted succesfully. File information after converted:"
    file $filename
}

yesNoSelection() {
    local message=$1

    echo $message
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) return 0;;
            No ) return 1;;
        esac
    done
}

doMain() {
    for file in "$@"
    do
	processOneFile "$file"
    done
}

doMain $@
exit 0
