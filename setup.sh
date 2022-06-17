#! /usr/bin/bash
PROJECTDIR=$(dirname $(readlink -f "$0"))

# Set pre-commit hook
cat scripts/pre-commit | sed -e "s%{{PROJECTDIR}}%${PROJECTDIR}%g" >.git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Install the requirements
ansible-galaxy install -r requirements.yml
vagrant plugin install vagrant-hostmanager

# Creates vault password file
read -sp "Enter the Ansible vault password: " VAULT_PASS
echo "${VAULT_PASS}" >.vault_pass
chmod 0600 .vault_pass
echo -e "\nProject initialized!"
