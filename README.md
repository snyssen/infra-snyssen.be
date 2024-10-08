# Infrastructure of snyssen.be

All the necessary instructions, docker files, scripts, etc. necessary for building my self hosted server (almost) from scratch.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

## Table of Contents

- [Infrastructure of snyssen.be](#infrastructure-of-snyssenbe)
  - [Table of Contents](#table-of-contents)
  - [Important notice](#important-notice)
  - [Objectives](#objectives)
  - [Hardware](#hardware)
  - [Requirements](#requirements)
  - [Getting started](#getting-started)
  - [Playbooks descriptions](#playbooks-descriptions)
    - [Setup playbooks](#setup-playbooks)
      - [Setup - deploy](#setup---deploy)
      - [Setup - restore](#setup---restore)
    - [Server playbooks](#server-playbooks)
      - [Server - wol (Wake-on-LAN)](#server---wol-wake-on-lan)
      - [Server - wipe](#server---wipe)
      - [Server - reboot](#server---reboot)
      - [Server - shutdown](#server---shutdown)
      - [Server - gather facts](#server---gather-facts)
    - [Stacks playbooks](#stacks-playbooks)
      - [Stacks - deploy](#stacks---deploy)
      - [Stacks - manage](#stacks---manage)
    - [Backup playbooks](#backup-playbooks)
      - [Backup - run](#backup---run)
      - [Backup - restore](#backup---restore)
      - [Backup - check](#backup---check)
      - [Backup - list snapshots](#backup---list-snapshots)
      - [Backup - get logs](#backup---get-logs)
    - [Snapraid playbooks](#snapraid-playbooks)
      - [Snapraid - runner execute](#snapraid---runner-execute)
      - [Snapraid - get logs](#snapraid---get-logs)
    - [Stacks specific playbooks](#stacks-specific-playbooks)
      - [Nextcloud occ](#nextcloud-occ)
      - [Minecraft execute](#minecraft-execute)
  - [Server schedule](#server-schedule)
    - [Morning schedule](#morning-schedule)
    - [Additional scheduled events](#additional-scheduled-events)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Important notice

As this project is in constant flux and I am the sole contributor, please bear in mind that this README could become out of sync with the actual repository content. You should also remember that the documentation and files present are firstly made for my own use. As such, I won't be responsible for any issue you might have when trying to reproduce my setup, and you should probably at least have some grasp of how to use Linux, Docker and Ansible before attempting this. That said, I am open to offer **some** help to adventurous people trying to make use of this repository.

## Objectives

As an avid [self-hoster](https://www.reddit.com/r/selfhosted/), I depend on my server for a plethora of everyday tasks. This repository includes everything I need to deploy all the services necessary for said tasks. Once fully operational, this servers allows me to, among other things:

- Reduce or eliminate my dependency to big corporations services. It can do so by:
  - Acting as a cloud file manager and backup (think Google Drive or One Drive)
  - Syncing my agenda and tasks using WebDav and CalDav, thus replacing Google Agenda and such
  - Offer private and secure instant messaging options, even though the usage will be limited as it can be hard to convince friends and loved ones to switch from known brands
- Automatically import and catalog my pictures
- Provide music, movies and tv shows anywhere, on any device
- Host my public and private source codes and projects
- Archive and organize my thoughts, problems and solutions
- Serve my various websites
- Play some games with friends
- Etc.

The list of services used and how to deploy them can be found under [The stacks](#the-stacks)

## Hardware

Here is the hardware currently used by the machine that runs everything listed in here. Please note that this does not serve as a required or min specs list but is rather provided as additional information.

- <u>CPU</u>: 8x Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz
- <u>RAM</u>: 4x 4GB Corsair(R) Vengeance Pro Series DDR3 memory
- <u>Motherboard</u>: MSI(R) Z97S SLI Krait edition
- <u>Cooling</u>: Stock Intel(R) cooling
- <u>Case</u>: Antec(R) P101 Silent
- <u>Storage</u>:
  - <u>System drive</u>: Western Digital(R) Blue 3D NAND SATA SSD M.2 2280 - 500GB
  - <u>Parity disk</u>: Seagate(R) Exos X14 - 12TB
  - <u>Storage disks</u>:
    - Seagate(R) IronWolf SATA3 5900RPM 64MB cache - 4TB
    - 3x Seagate(R) IronWolf SATA3 5900RPM 64MB cache - 2TB

Most of the hardware was actually scavenged from a previous gaming PC build. Recycling yay!

## Requirements

- A server with at least 1 system drive, 1 parity drive and 1 data drive. The server should be running Fedora server (it may work with other RedHat based distro but I haven't tested it. **Non RedHat based distro are not supported at the moment** as the playbooks depend on dnf)
- A computer with ansible, VirtualBox and vagrant (for testing) installed, as well as npm (for installing doctoc)
- The ability to connect from the client machine to the server using SSH with key-based authentication. You can learn how to manage SSH keys [here](https://wiki.snyssen.be/en/sys-admin/linux/ssh-keys).
- Some free time and lots of coffee

## Getting started

Clone the repos on the client machine (the one with Ansible installed) and cd into it:

```bash
git clone https://github.com/snyssen/infra-snyssen.be.git && cd infra-snyssen.be
```

Run the setup script:

```bash
./setup.sh
```

This script will do the following:

1. Set a pre-commit hook to prevent you from making commits without encrypting the Ansible vaults first.
2. Install the Ansible, Vagrant and other requirements.
3. Create the ansible password file for encrypting and decrypting the vaults. You will be asked for the encryption key. **The generated file (`.vault_pass`) should of course never be committed.**

To build the test virtual machine, run:

```bash
vagrant up
```

This should create a virtual machine and provision it with Ansible. If you are satisfied with the results, change the `hosts/prod.yml` Ansible inventory file so it points to your own server, then rename the `host_vars/snyssen.be` folder to your server hostname or ip address (whatever you put in the inventory file) and change the variables files found in this folder for your use. Finally, apply the changes to your server by running:

```bash
ansible-playbook setup-deploy.yml -i=hosts/prod.yml
```

## Playbooks descriptions

Playbooks follow the `context-action.yml` filename scheme. As such, they are ordered by context. For each demonstrated command, parts in `[]` are optional, additional variables, and comma separated list in `{}` indicate possible values for such variables (where applicable).

For each playbook, multiple environments are available and should be configured for your use case. ENvironments are defined as inventory files in `/hosts`. There are currently 3 environments:
- dev: Should be used with vagrant for development. See [getting started](#getting-started) for more information
- staging: Should be used with an expandable server, for final testing before actual deployment
- prod: Should be used for actual production deployment

The dev environment is the default one: if you don't specify the environment to use, all playbooks will be run against this one. You can specify the inventory with the `-i` flag:

```bash
ansible-playbook <playbook_file.yml> -i hosts/<inventory_file.yml>
```

### Setup playbooks

#### Setup - deploy

Use this playbook to deploy a fresh instance of the server. For example, to have a fresh instance on staging use:

```bash
ansible-playbook setup-deploy.yml [-e "docker_compose_state={present,absent,restarted} stacks_deploy_list=['backbone','nextcloud']"]
```

- `docker_compose_state` (default = present): The state of the stacks after they are deployed
- `stacks_deploy_list`: Explicitly defines the list of stacks that should be deployed. If undefined, all stacks are deployed; otherwise only specified stacks are.

#### Setup - restore

Restore a previous server backup from scratch. This is useful for disaster recovery.

```bash
ansible-playbook setup-restore.yml [-e "restic_server={local,remote} stacks_deploy_list=['backbone','nextcloud']"]
```

- `restic_server` (default = local): The backup server to use. `local` refers to a LAN accessible restic rest server that is deployed along the main server; `remote` refers to a WAN accessible s3 bucket.
- `stacks_deploy_list`: Explicitly defines the list of stacks that should be deployed. If undefined, all stacks are deployed; otherwise only specified stacks are.

The playbook requires user input during execution to choose the file backup and then database backups to restore.

### Server playbooks

#### Server - wol (Wake-on-LAN)

Sends a magic packet to wake supported servers on LAN. The backup server is the sole server having this capability at the moment.

```bash
ansible-playbook [-i hosts/prod.yml] server-wol.ansible.yml
```

#### Server - wipe

Completely wipes the apps server, stopping all applications and destroying all the data. This is usually only used during development, as a faster way to iterate without having to fully recreate the VM.

```bash
ansible-playbook server-wipe.ansible.yml
```

#### Server - reboot

Reboots the server(s). It is recommended to use the `--limit` flag to only apply this to a single group, as you usually don't want to reboot all your servers but only one at a time.

```bash
ansible-playbook server-reboot.yml [--limit={apps,backup}] [-e "reboot_delay=300 prevent_apps_restart={true,false}"]
```

- `reboot_delay`: The delay (in seconds) the server should wait before rebooting. Values below 60 are ignored. If not explicitly set, will be asked to user on playbook execution.
- `prevent_apps_restart` (default = false): Whether all apps should be restarted or not after reboot. If set to true, apps won't be restarted.

#### Server - shutdown

Shutdowns the server(s). It is recommended to use the `--limit` flag to only apply this to a single group, as you usually don't want to shutdown all your servers but only one at a time.

```bash
ansible-playbook server-shutdown.yml [--limit={apps,backup}] [-e "shutdown_delay=300"]
```

- `shutdown_delay`: The delay (in seconds) the server should wait before shutting down. Values below 60 are ignored. If not explicitly set, will be asked to user on playbook execution.

#### Server - gather facts

Gather all facts about all servers and output them to console.

```bash
ansible-playbook -i hosts/prod.yml server-gather-facts.ansible.yml [--limit={apps,backup,dns}]
```

### Stacks playbooks

#### Stacks - deploy

Deploys all stacks to the app server.

```bash
ansible-playbook stacks-deploy.yml [-e "docker_compose_state={present,absent,restarted} stacks_deploy_list=['backbone','nextcloud']"]
```

- `docker_compose_state` (default = present): The state of the stacks after they are deployed
- `stacks_deploy_list`: Explicitly defines the list of stacks that should be deployed. If undefined, all stacks are deployed; otherwise only specified stacks are.

#### Stacks - manage

Changes the state of specific stacks.

```bash
ansible-playbook stacks-manage.yml [-e "stacks_state={present,absent,restarted} stacks_include_str='nextcloud restic' stacks_exclude_str='speedtest photoprism'"]
```

- `stacks_state`: Sets the stack state. If not explicitly set, will be asked to user on playbook execution.
- `stacks_include_str`: Space separated list of stacks names which state should be changed. Leave empty to include all apps. Note that this setting is mutually exclusive with the 'stacks_exclude' one; if both are set, only this one will be used.
- `stacks_exclude_str`: Space separated list of stacks names which state should **not** be changed. Leave empty to not exclude any app.

### Backup playbooks

#### Backup - run

Backs up the server.

```bash
ansible-playbook backup-run.yml [-e "backup_skip_databases={true,false} backup_skip_files={true,false} backup_files_skip_local={true,false} backup_files_skip_remote={true,false}"]
```

- `backup_skip_databases` (default = false): Whether to skip the databases backups or not. If set to true, no database backup will be made.
- `backup_skip_files` (default = false): Whether to skip the files backup or not. If set to true, no file will be backed up.
- `backup_files_skip_local` (default = false): Whether to skip the local backup or not. If set to true, files won't be saved to the local backup server.
- `backup_files_skip_remote` (default = false): Whether to skip the remote backup or not. If set to true, files won't be saved to the remote backup server.

#### Backup - restore

Restores a server backup.

```bash
ansible-playbook backup-restore.yml [-e "backup_skip_files={true,false} backup_skip_databases={true,false} restic_server={local,remote} db_restore_include=['nextcloud', 'photoprism'] db_restore_exclude=['recipes']"]
```

- `backup_skip_databases` (default = false): Whether to skip the databases restore or not. If set to true, no database will be restored.
- `backup_skip_files` (default = false): Whether to skip the files restore or not. If set to true, no file will be restored.
- `restic_server` (default = local): The backup server to use. `local` refers to a LAN accessible restic rest server that is deployed along the main server; `remote` refers to a WAN accessible s3 bucket.
- `db_restore_include` (default = all): databases to restore. If left empty, all dbs are included. Note that this setting is mutually exclusive with 'db_restore_exclude'; if both are set, only this one will be used
- `db_restore_exclude` (default = none): databases that should not be restored

#### Backup - check

Checks all snapshots.

```bash
ansible-playbook [-i hosts/prod.yml] backup-check.ansible.yml [-e "restic_server={local,remote}"]
```

#### Backup - list snapshots

List all available snapshots.

```bash
ansible-playbook [-i hosts/prod.yml] backup-list-snapshots.ansible.yml [-e "restic_server={local,remote}"]
```

#### Backup - get logs

Get logs of latest backup run

```bash
ansible-playbook [-i hosts/prod.yml] backup-get-logs.ansible.yml [-e "restic_server={local,remote}"]
```

### Snapraid playbooks

#### Snapraid - runner execute

Executes the snapraid-runner on the apps server.

```bash
ansible-playbook [-i hosts/prod.yml ]snapraid-runner-execute.ansible.yml [-e "snapraid_runner_ignore_threshold=true skip_healthcheck=true"]
```

- `snapraid_runner_ignore_threshold` (default = false): ignore the default delete threshold, allowing snapraid to be run even after a large delete operation.
- `skip_healthcheck` (default = false): do not trigger the healthcheck upon successful completion

#### Snapraid - get logs

Retrieves logs from the latest snapraid run.

```bash
ansible-playbook [-i hosts/prod.yml] snapraid-get-logs.ansible.yml
```

### Stacks specific playbooks

#### Nextcloud occ

Runs an occ command inside the Nextcloud instance. The command is prompted before executing it. It should not contain the `occ` part but only its args.

```bash
ansible-playbook [-i hosts/prod.yml] nextcloud-occ.ansible.yml
```

#### Minecraft execute

Runs a command inside the Minecraft console. The command is prompted before executing it.

```bash
ansible-playbook [-i hosts/prod.yml] minecraft-execute.ansible.yml
```

## Server schedule

All times are on the Europe/Brussels timezone.

### Morning schedule

| 00:00             | 01:00    | 03:00           | 04:00 | 05:00            | 06:00 |
| ----------------- | -------- | --------------- | ----- | ---------------- | ----- |
| nextcloud db dump | snapraid | restic to local |       | restic to remote |       |
| gitea db dump     |          |                 |       |                  |       |
| recipes db dump   |          |                 |       |                  |       |

### Additional scheduled events

  - Packages upgrades at 08:00 on saturdays. **Warning: might incur a server reboot!**
  - Nextcloud background jobs every 5 minutes (on the clock).
