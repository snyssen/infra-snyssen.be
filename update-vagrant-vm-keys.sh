ssh-keyscan snyssen.duckdns.org >> ~/.ssh/known_hosts
ssh-keyscan backup.sny >> ~/.ssh/known_hosts
ssh-copy-id vagrant@snyssen.duckdns.org
ssh-copy-id vagrant@backup.sny