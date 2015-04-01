#!/bin/bash

declare -r host="$1"
declare -ir port=$2
declare -r user="$3"
declare -r database="$4"
declare -r command="select datname from pg_database where datistemplate = 'false';"

declare names=""
for name in $(zabbix-psql.sh "$host" $port "$user" "$database" "$command"); do
    names="$names,"'{"{#DB_NAME}":"'$name'"}'
done

echo '{"data":['${names#,}']}'
