# Setup environment
setup: setup-precommit setup-vault setup-deps

# Setup pre-commit hook
setup-precommit:
  pre-commit install --install-hooks --overwrite

# Save ansible-vault password in local hidden file
setup-vault:
  read -rsp "Enter the Ansible vault password: " VAULT_PASS && echo "${VAULT_PASS}" >.vault_pass
  chmod 0600 .vault_pass

# Install ansible galaxy dependencies according to requirements.yml file
setup-deps:
  ansible-galaxy install -r requirements.yml

# Forcefully update ansible galaxy dependencies
update-deps:
  ansible-galaxy install -r requirements.yml --force