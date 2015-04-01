#!/bin/bash

declare -r host="$1"
declare -ir port=$2
declare -r user="$3"
declare -r database="$4"
declare -r dbCommand="select datname from pg_database where datistemplate = 'false';"

declare tableNames=""
for dbName in $(zabbix-psql.sh "$host" $port "$user" "$database" "$dbCommand"); do
    declare tableCommand="\
        select \
            row_to_json(t) \
        from (\
	    select \
                current_database() as \"{#DB_NAME}\", \
                schemaname as \"{#SCHEMA_NAME}\", \
                tablename as \"{#TABLE_NAME}\" \
            from pg_tables \
            where \
                schemaname not in ('pg_catalog', 'information_schema')\
            ) as t\
        ;"
    for tableName in $(zabbix-psql.sh "$host" $port "$user" "$dbName" "$tableCommand"); do
	tableNames="$tableNames,"$tableName
    done
done

echo '{"data":['${tableNames#,}']}'
