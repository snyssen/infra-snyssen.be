ssh-keyscan snyssen.sny >> ~/.ssh/known_hosts
ssh-keyscan backup.sny >> ~/.ssh/known_hosts
ssh-copy-id vagrant@snyssen.sny
ssh-copy-id vagrant@backup.sny