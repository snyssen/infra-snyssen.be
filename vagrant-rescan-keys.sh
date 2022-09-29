#! /usr/bin/bash
# Builds a list of all the virtual machines hosts
hosts=("snyssen.duckdns.org " "backup.sny")
# Then scans the public key of each of those hosts, replacing the previously known one
for host in "${hosts[@]}"; do
	ssh-keyscan "${host}" >>~/.ssh/known_hosts
done
