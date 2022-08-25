# Infrastructure of snyssen.be

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)

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
      - [Server - reboot](#server---reboot)
      - [Server - shutdown](#server---shutdown)
    - [Packages playbooks](#packages-playbooks)
      - [Packages - upgrade](#packages---upgrade)
    - [Stacks playbooks](#stacks-playbooks)
      - [Stacks - deploy](#stacks---deploy)
      - [Stacks - manage](#stacks---manage)
    - [Backup playbooks](#backup-playbooks)
      - [Backup - run](#backup---run)
      - [Backup - restore](#backup---restore)
  - [The stacks](#the-stacks)
    - [The `backbone` stack](#the-backbone-stack)
    - [The `nextcloud` stack](#the-nextcloud-stack)
    - [The `Photoprism` stack](#the-photoprism-stack)
    - [The `recipes` stack](#the-recipes-stack)
    - [The `restic` stack](#the-restic-stack)
    - [The `speedtest` stack](#the-speedtest-stack)
    - [The `streaming` stack](#the-streaming-stack)
    - [The `piped` stack](#the-piped-stack)
    - [The `git` and `cicd` stacks](#the-git-and-cicd-stacks)
    - [The `dashboard` stack](#the-dashboard-stack)
  - [Server schedule](#server-schedule)

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
  - <u>Parity disk</u>: Seagate(R) IronWolf SATA3 5900RPM 64MB cache - 4TB
  - <u>Storage disks</u>: 3x Seagate(R) IronWolf SATA3 5900RPM 64MB cache - 2TB

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
ansible-playbook setup-deploy.yml [-e "docker_compose_state={present,absent,restarted} skip_snapraid={true,false}"]
```

- `docker_compose_state` (default = present): The state of the stacks after they are deployed
- `skip_snapraid` (default = false): If set to true, does not install snapraid. This is useful if you have limited hard drives available and you don't want to use one for parity

#### Setup - restore

Restore a previous server backup from scratch. This is useful for disaster recovery.

```bash
ansible-playbook setup-restore.yml [-e "skip_snapraid={true,false} restic_server={local,remote}"]
```

- `skip_snapraid` (default = false): If set to true, does not install snapraid. This is useful if you have limited hard drives available and you don't want to use one for parity
- `restic_server` (default = local): The backup server to use. `local` refers to a LAN accessible restic rest server that is deployed along the main server; `remote` refers to a WAN accessible s3 bucket.

The playbook requires user input during execution to choose the file backup and then database backups to restore.

### Server playbooks

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

### Packages playbooks

#### Packages - upgrade

Upgrades all DNF packages on the server(s).

```bash
ansible-playbook packages-upgrade.yml
```

### Stacks playbooks

#### Stacks - deploy

Deploys all stacks to the app server.

```bash
ansible-playbook stacks-deploy.yml [-e "docker_compose_state={present,absent,restarted}"]
```

- `docker_compose_state` (default = present): The state of the stacks after they are deployed

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

## The stacks

### The `backbone` stack

The backbone is what makes all the other services accessible. Its is currently only composed of [Traefik](https://github.com/traefik/traefik), a reverse proxy that automatically forwards requests to the necessary containers based on the subdomain used. It is also responsible for generating SSL certificates for all of those services by using the Let's Encrypt API. Its UI can be accessed at `routing.your.domain`.

### The `nextcloud` stack

The nextcloud stack provides a [Nextcloud](https://nextcloud.com) instance with all of its dependencies. The service is accessible at `cloud.your.domain`.

### The `Photoprism` stack

[Photoprism](https://photoprism.app) is a convenient app to browse and manage your pictures library. The picture folder is shared with the [Nextcloud](#the-nextcloud-stack) container so images can be added through NextCloud, even allowing for automatic export from your phone directly into Photoprism! Photoprism can be found at `photo.your.domain`.

### The `recipes` stack

This stack provides the [Tandoor](https://tandoor.dev) recipes app at `recipes.your.domain`.

### The `restic` stack

Restic is used to backup the files of your server. It does not provide any UI.

### The `speedtest` stack

This stack offers a [simple speedtest](https://github.com/librespeed/speedtest) which can be useful to troubleshoot connection issues with your server.

### The `streaming` stack

The streaming stack offers all kind of streaming services, mainly through [Jellyfin](https://jellyfin.org) (accessible on `streaming.your.domain`). It also provides some *Arrs apps for library management.

### The `piped` stack

[Piped](https://github.com/TeamPiped/Piped) is a self-hostable alternative front-end for Youtube. It provides better privacy, ads and sponsors blocking. It can be accessed on `yt.your.domain`.

### The `git` and `cicd` stacks

The git stack provides a [Gitea](https://gitea.io/en-us/) instance at `git.your.domain`. This Gitea instance can be used to store git repositories, built packages, and to do project management and documentation. It has an accompanying "cicd" stack that deploys a [Drone](https://www.drone.io) instance (at `drone.your.domain`) for all your CI/CD needs.

### The `dashboard` stack

This stack provides a starting page to easily access all of the other deployed services as well as any other webpage you would like. Currently it uses [Heimdall](https://heimdall.site), but I am quite disappointed by the current offering of self-hosted starting pages, so I am thinking of creating my own when I get the time. The dashboard is accessible at `dash.your.domain`.

## Server schedule
