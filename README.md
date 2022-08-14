# Infrastructure of snyssen.be

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)

All the necessary instructions, docker files, scripts, etc. necessary for building my self hosted server (almost) from scratch.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

## Table of Contents

- [Important notice](#important-notice)
- [Objectives](#objectives)
- [Hardware](#hardware)
- [Requirements](#requirements)
- [Getting started](#getting-started)
- [Playbooks descriptions](#playbooks-descriptions)
  - [1. The "playbook" playbook](#1-the-playbook-playbook)
  - [2. The setup playbook](#2-the-setup-playbook)
  - [3. The maintenance playbook](#3-the-maintenance-playbook)
  - [4. The docker playbook](#4-the-docker-playbook)
- [Web services](#web-services)
  - [1. The backbone](#1-the-backbone)
  - [2. Jellyfin](#2-jellyfin)

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

The list of services used and how to deploy them can be found under [Web services](#web-services)

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

This should create a virtual machine and provision it with Ansible. If you are satisfied with the results, change the `hosts/prod.yml` Ansible inventory file so it points to your own server, then rename the `host_vars/192.168.1.10` folder to your server hostname or ip address (whatever you put in the inventory file) and change the variables files found in this folder for your use. Finally, apply the changes to your server by running:

```bash
ansible-playbook playbook.yml --inventory=hosts/prod.yml
```

## Playbooks descriptions

### 1. The "playbook" playbook

```bash
ansible-playbook playbook.yml
```

This playbook turns any fresh machine into the complete server we want it to be. It basically uses all of the tasks and roles defined in this repos.

### 2. The setup playbook

```bash
ansible-playbook setup.yml
```

This playbook will run the setup role, which will:

1. Install the necessary softwares (snapraid and snapraid-runner, docker, mergerfs, etc.);
2. Setup the correct disk configuration according to the variables set in the hosts file. It will then configure snapraid and mergerfs and set the necessary cron;
3. Setup a nice user shell with OhMyZsh and the PowerLevel10k theme

### 3. The maintenance playbook

```bash
ansible-playbook maintenance.yml
```

This playbook will simply update all the installed software using dnf.

### 4. The docker playbook

```bash
ansible-playbook docker.yml
```

This playbook will deploy all the containers for the various docker stacks that should be present on the server. You can find [the list of the services provided](#web-services) below.

## Web services

### 1. The backbone

The backbone is what makes all the other services accessible. Its is currently only composed of [Traefik](https://github.com/traefik/traefik), a reverse proxy that automatically forwards requests to the necessary containers based on the subdomain used. It is also responsible for generating SSL certificates for all of those services by using the Let's Encrypt API. Its UI can be accessed at `routing.your.domain`.

### 2. Jellyfin

[Jellyfin](https://jellyfin.org) is part of the streaming stack
