#!/bin/bash

MAX_WORKSPACES=5
eval WORKSPACE_LIST=({1..$MAX_WORKSPACES})
eval WORKSPACE_STR=({1..$MAX_WORKSPACES})
ACTIVE_ICON=""
INACTIVE_ICON=""

# Empty Array
output=()

for i in "${WORKSPACE_STR[@]}"
do 
    output+=("$i")
    #output+=(" ")
done

monitors=$(hyprctl monitors | grep "ID" | awk '{print $4}' | sed 's/):/ /g')

active_workspace=$(hyprctl activewindow | grep "workspace:" | awk '{print $2}')
active_monitor=$(hyprctl activewindow | grep "monitor:" | awk '{print $2}')
aws=$(( (active_workspace - 1) % MAX_WORKSPACES + 1))
#echo "$active_workspace"

for mon in $monitors
do
    for i in "${WORKSPACE_LIST[@]}"
    do 
        if [ "$mon" -eq "$active_monitor" ] && [ "$i" -eq "$aws" ]; then 
            #echo "$i"
            index=($i - 1)
            #output=( "${output[@]:0:$index}" "X" "${output[@]:$index}" )
            output[$index]="X"
        fi
    done
done

echo "${output[@]}"



