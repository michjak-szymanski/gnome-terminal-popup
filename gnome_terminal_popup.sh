#!/bin/bash
#
# This script should pop out Gnome terminal window(s).
# If none exists yet then a new one will be created.
# 
# Author: Michał Szymański <michjak.szymanski@gmail.com>
#

find_gnome_terminal_server_pid(){
    echo $(ps -aux | grep 'gnome-terminal-server' | grep -v 'grep' | awk -F ' ' '{print $2}')
}

# get gnome-terminal-server PID
gnome_server_pid=$(find_gnome_terminal_server_pid)

if [ -z "${gnome_server_pid//}" ]
    then
        gnome-terminal --window
        gnome_server_pid=$(find_gnome_terminal_server_pid)
    fi

# get (all) open gnome-terminal windows ids
gnome_server_window_ids=$(wmctrl -lp | grep $gnome_server_pid | awk -F ' ' '{print $1}')

# show all gnome-terminal windows on current desktop
for window_id in $gnome_server_window_ids 
    do 
        wmctrl -i -a $window_id 
    done
