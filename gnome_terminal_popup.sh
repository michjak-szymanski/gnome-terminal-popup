#!/bin/bash
#
# This script should pop out Gnome terminal window(s).
# If none exists yet then a new one will be created.
# On the other hand, if all terminal's windows are already visible,
# then all of them will be minimized (toggle feature).
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
        exit 0
    fi

# get (all) open gnome-terminal windows ids
gnome_server_window_ids=$(wmctrl -lp | grep $gnome_server_pid | awk -F ' ' '{print $1}')

# hide all gnome terminal windows if they are open
total_gnome_server_windows=0
visible_gnome_server_windows=0

for window_id in $gnome_server_window_ids 
    do 
        window_info=$(xprop -id $window_id)
        window_state_normal_matches=$(echo $window_info | grep 'window state: Normal' -c)

        if [[ $window_state_normal_matches -eq "1" ]]
            then
                visible_gnome_server_windows=$(($visible_gnome_server_windows + 1))
            fi 
        
        total_gnome_server_windows=$(($total_gnome_server_windows + 1))
    done

if [ $total_gnome_server_windows -eq $visible_gnome_server_windows ]
    then 
        for window_id in $gnome_server_window_ids 
            do 
                xdotool windowminimize $window_id
            done

        exit 0
    fi

# show all gnome-terminal windows on current desktop
for window_id in $gnome_server_window_ids 
    do 
        wmctrl -i -a $window_id 
    done
