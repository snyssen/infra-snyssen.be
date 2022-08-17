#! /usr/bin/bash

vagrant ssh snyssen.duckdns.org -c "sudo nmcli connection modify 'Wired connection 1' IPV4.address 192.168.56.12/24 && sudo reboot"
