# Infrastructure of snyssen.be

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)

All the necessary instructions, docker files, scripts, etc. necessary for building my self hosted server (almost) from scratch.

## Table of contents

- [Infrastructure of snyssen.be](#infrastructure-of-snyssenbe)
  - [Table of contents](#table-of-contents)
  - [Important notice](#important-notice)
  - [Objectives](#objectives)
  - [Hardware](#hardware)
  - [Requirements](#requirements)
  - [Getting started](#getting-started)
    - [Other playbooks](#other-playbooks)
      - [1. The setup playbook](#1-the-setup-playbook)
      - [2. The maintenance playbook](#2-the-maintenance-playbook)
      - [3. The docker playbook](#3-the-docker-playbook)
- [Everything below is still WIP](#everything-below-is-still-wip)
  - [Docker stacks list](#docker-stacks-list)
    - [Backbone](#backbone)
      - [What it is](#what-it-is)
      - [How to use](#how-to-use)

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

The list of services used and how to deploy them can be found under [Docker stacks list](#docker-stacks-list)

## Hardware

Here is the hardware currently used by the machine that runs everything listed in here. Please note that this does not serve as a required or min specs list but is rather provided as additional information.

- <u>CPU</u>: 8x Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz
- <u>RAM</u>: 4x 4GB  Corsair(R) Vengeance Pro Series DDR3 memory
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
- A computer with ansible installed
- The ability to connect from the client machine to the server using SSH with key-based authentication. You can learn how to manage SSH keys [here](https://wiki.snyssen.be/en/sys-admin/linux/ssh-keys).
- Some free time and lots of coffee

## Getting started

Clone the repos on the client machine (the one with Ansible installed) and cd into it

```bash
git clone https://github.com/snyssen/infra-snyssen.be.git && cd infra-snyssen.be
```

Decrypt the variables vault using

```bash
ansible-vault decrypt vars/vault.yml
```

then modify the variables using your own values. You can also make use of the `vars/vault.example.yml` instead.

Set your host and its necessary variables (look at the existing examples) in the `hosts.yml` file.

When ready, deploy to your server with:

```bash
ansible-playbook playbook.yml --limit prod --ask-become-pass --ask-vault-pass
```

It will ask for the sudo password of the server and your variables vault password before running the entire playbook.

You can also run separate playbooks for the different steps:

### Other playbooks

#### 1. The setup playbook

```bash
ansible-playbook setup.yml --limit prod --ask-become-pass --ask-vault-pass
```

This playbook will run the setup role, which will:

1. Install the necessary softwares (snapraid and snapraid-runner, docker, mergerfs, etc.);
2. Setup the correct disk configuration according to the variables set in the hosts file. It will then configure snapraid and mergerfs and set the necessary cron;
3. Setup a nice user shell with OhMyZsh and the PowerLevel10k theme

#### 2. The maintenance playbook

```bash
ansible-playbook maintenance.yml --limit prod --ask-become-pass --ask-vault-pass
```

This playbook will simply update all the installed software using dnf.

#### 3. The docker playbook

```bash
ansible-playbook docker.yml --limit prod --ask-become-pass --ask-vault-pass
```

This playbook will deploy all the containers for the various docker stacks that should be present on the server. You can find [the list of those stacks](#docker-stacks-list) below.

# Everything below is still WIP

## Docker stacks list

Below you will find the list of all the stacks used to provide the various services of my server. For each stack you will have a description of its purpose as well as how to deploy and use the stack.

### Backbone

#### What it is

The "backbone" is the stack that is used to link and control all the others stacks. It is compose of 2 containers:

- [Traefik](https://traefik.io/) is used as the reverse proxy for all the other stacks. It will automatically (or well, thanks to configuration) detect new containers that should be exposed to the Internet and will forward them as well as generate new SSL certificates for them using Let's Encrypt.
- [Portainer](https://www.portainer.io/) is optional but is a nice addition that offers a GUI to list and controls the various stacks and containers. I most often use it to access the logs of the containers when debug is needed, as well as to input manual commands inside the containers.

#### How to use

There are 3 environment variables that you should configure in the `.env` file:

1. <u>DOCKER_DIRECTORY</u> is the directory used to store the fast changing files of each container. As such, it should **not** point to a directory inside the **SnapRAID backed disk** as such fast changing files won't play nice with the parity snapshots of SnapRAID.
2. <u>LETSENCRYPT_EMAIL</u> is the email used when creating the Let's Encrypt certificates.
3. <u>TRAEFIK_DASHBOARD_HTPASSWORD</u> is the username and password used to access the Traefik dashboard (through basic authentication). You can use a generator for it such as [this one](https://wtools.io/generate-htpasswd-online).

Once you have changed those environment variables, start the stack with

```
docker-compose up -d
```

Once it is done, you should be able to connect to the Traefik dashboard at `routing.<your_domain>`. You should also go to `docker.<your_domain>` to configure Portainer for first time use.