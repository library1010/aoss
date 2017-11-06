# Dump database table
This is a shell script to dump database tables in the most convinience way.

## Usage
You need to do the following thing:
1. Declare the variables on the `db_define/define.sh` (_first run only_)
2. Declare the tables you want to back up on `tables.txt` on the following convention:
```
<schema> <table> <supplier> [<options>]
```
3. Run the following command
```
$ ./dump_to_backup.sh
```
