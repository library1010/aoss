#!/bin/sh

# NO WARRANTY!!
# Use it and take your own risk

CMDNAME=`basename $0`
script_dir=~/bin/asiagate/dump_table

backupTables() {
    local schema="$1"
    local table="$2"
    local supplier="$3"
    local option="$4"
    local file_path=~/DUMP_SQL/`echo $supplier | awk '{print toupper($0)}'`/"$table"_`date +%Y%m%d`.sql

    echo ""
    echo "[Dump file backup info]"
    echo "Table: $schema.$table"
    echo "Dump file location: $file_path"
    echo "Supplier: $supplier"
    
    mkdir -p ${file_path%/*}
    checkError $? "Error when create folder."

    set -x
    mysqldump -h$host -u$username -p$password -P$port $schema $table $option > $file_path
    set +x
    checkError $? "Error when create sqldump file."
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

backupGetFromFile() {
    local db_def="$1"
    local tables_list="$2"
    
    . $script_dir/$db_def

    while read -r line || [[ -n "$line"  ]]; do
	backupTables $line
    done < $script_dir/$tables_list
}

doMain() {
    backupGetFromFile db_define/define.sh tables.txt
}

doMain
exit 0
