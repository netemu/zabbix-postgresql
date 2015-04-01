#!/bin/bash

declare -r host="$1"
declare -ir port=$2
declare -r user="$3"
declare -r database="$4"
declare -r command="$5"

exec psql -h "$host" -p $port -U "$user" -d "$database" -t -c "$command" 2>/dev/null
