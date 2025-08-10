#!/bin/bash

# Initialize ncurses
tput init
stty -echo

# Function to draw border
draw_border() {
    tput clear
    cols=$(tput cols)
    rows=$(tput lines)
    
    # Draw border
    tput cup 0 0
    echo "╭$(printf '%0.s─' $(seq 1 $((cols-2))))╮"
    for i in $(seq 1 $((rows-3))); do
        tput cup $i 0; echo "│"
        tput cup $i $((cols-1)); echo "│"
    done
    tput cup $((rows-2)) 0
    echo "╰$(printf '%0.s─' $(seq 1 $((cols-2))))╯"
}

# Function to display menu
display_menu() {
    draw_border
    
    # Title
    tput cup 2 $(( (cols - 14) / 2 ))
    echo "┌ PILIH SISTEM ┐"
    
    # Menu items
    tput cup 4 $(( (cols - 20) / 2 ))
    echo "${selected[0]}› s. shutdown"
    tput cup 5 $(( (cols - 20) / 2 ))
    echo "${selected[1]}› p. Poweroff"
    tput cup 6 $(( (cols - 20) / 2 ))
    echo "${selected[2]}› r. reboot"
    tput cup 7 $(( (cols - 20) / 2 ))
    echo "${selected[3]}› w. Masuk ke SDDM"
    tput cup 8 $(( (cols - 20) / 2 ))
    echo "${selected[4]}› h. Hibernasi"
    
    # Footer
    tput cup $((rows-3)) $(( (cols - 30) / 2 ))
    echo "Gunakan tombol panah atau klik mouse"
}

# Main function
main() {
    notify-send "sistem keluar"
    pkill mpd
    
    # Unmount and power off devices
    sudo udisksctl unmount -b /dev/sdb1
    sudo udisksctl power-off -b /dev/sdb
    sudo udisksctl unmount -b /dev/sda1
    sudo udisksctl power-off -b /dev/sda
    sudo udisksctl unmount -b /dev/disk/by-id/usb-JMicron_Generic_0123456789ABCDEF-0:0-part1
    sudo udisksctl power-off -b /dev/disk/by-id/usb-JMicron_Generic_0123456789ABCDEF-0:0
    
    # Enable mouse support
    printf "\e[?1000h"
    
    local selected=(" " " " " " " " " ")
    local current=0
    
    # Display menu and get selection
    while true; do
        selected=(" " " " " " " " " ")
        selected[$current]="→"
        display_menu
        
        # Read input
        IFS= read -rsn1 key
        
        # Handle arrow keys
        if [[ $key == $'\e' ]]; then
            read -rsn2 -t 0.1 key2
            key+="$key2"
            case $key in
                $'\e[A') ((current--)); [[ $current -lt 0 ]] && current=4;;
                $'\e[B') ((current++)); [[ $current -gt 4 ]] && current=0;;
            esac
            continue
        fi
        
        # Handle mouse clicks (simplified)
        if [[ $key == $'\e' ]] && [[ $key2 == $'[<' ]]; then
            read -rsn3 -t 0.1 mouse
            continue
        fi
        
        # Handle selection
        case $key in
            s|1) 
                echo "shutting down in 5 seconds"
                mpv --screen=1 --fs --fs-screen=1 ~/wollpeper/exit.mp4
                sudo poweroff;
                break;;
            p|2) swaylock; break;;
            r|3) sudo reboot; break;;
            w|4) 
                hyprctl dispatch exit
                pkill Hypr; 
                break;;
            h|5) 
                echo "hibernotting"
                loginctl hibernate; 
                break;;
            "") 
                case $current in
                    0) 
                        echo "shutting down in 5 seconds"
                        mpv --screen=1 --fs --fs-screen=1 ~/wollpeper/exit.mp4
                        sudo poweroff;
                        break;;
                    1) swaylock; break;;
                    2) sudo reboot; break;;
                    3)
                        hyprctl dispatch exit
                        pkill Hypr;
                        break;;
                    4)
                        echo "hibernotting"
                        loginctl hibernate;
                        break;;
                esac;;
            q) break;;
            *) 
                tput cup $((rows-4)) $(( (cols - 30) / 2 ))
                echo "Pilihan tidak valid!"
                sleep 1
                ;;
        esac
    done
    
    # Clean up
    printf "\e[?1000l"
    stty echo
    tput clear
}

main