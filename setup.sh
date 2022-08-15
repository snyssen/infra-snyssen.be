#! /usr/bin/bash
SCRIPTPATH=$(readlink -f "$0")
PROJECTDIR=$(dirname "${SCRIPTPATH}")

# Set pre-commit hook
sed -e "s%{{PROJECTDIR}}%${PROJECTDIR}%g" scripts/pre-commit >.git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Install the requirements
ansible-galaxy install -r requirements.yml
vagrant plugin install vagrant-hostmanager

# Creates vault password file
read -rsp "Enter the Ansible vault password: " VAULT_PASS
echo "${VAULT_PASS}" >.vault_pass
chmod 0600 .vault_pass
echo -e "\nProject initialized!"
