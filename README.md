# Infrastructure of snyssen.be

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)

All the necessary instructions, docker files, scripts, etc. necessary for building my self hosted server (almost) from scratch.

## Table of contents

[TOC]

## Important notice

As this project is in constant flux and I am the sole contributor, please bear in mind that this README could become out of sync with the actual repository content. You should also remember that the documentation and files present are firstly made for my own use. As such, I won't be responsible for any issue you might have when trying to reproduce my setup, and you should probably at least have some grasp of how to use Linux and Docker before attempting this. That said, I am open to offer **some** help to adventurous people trying to make use of this repository.

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

The list of services used and how to deploy them can be found under [Docker stacks list](#Docker-stacks-list)

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

Follow the [Bare Metal installation](https://perfectmediaserver.com/installation/manual-install.html) instructions from the great tutorial/wiki of [Alex Kretzschmar](https://www.linkedin.com/in/alex-kretzschmar/), [Perfect Media Server](https://perfectmediaserver.com/). In the end, you should have :

- At least one parity disk for [SnapRAID](https://www.snapraid.it/). Parity disks naming scheme should follow `parity1`, `parity2`, etc.
- At least one storage HDD. storage disks should follow the naming scheme `disk1`, `disk2`, etc. and then be pooled by [MergerFS](https://github.com/trapexit/mergerfs) under `/mnt/storage`
- Automatic `scrub` and `sync` for  [SnapRAID](https://www.snapraid.it/) using [snapraid-runner](https://github.com/Chronial/snapraid-runner)
- A valid docker and docker compose installation

A valid domain name is also necessary for this installation. Mine is actually hard coded into all of the `docker-compose.yml` files, meaning you will have to change the files yourself if you intend to use my code. This will probably change in the future though.

## Deployment

Start by first cloning this repository onto the machine you want to use as your server.

```
git clone https://github.com/snyssen/infra-snyssen.be.git
```

Each service is deployed using a specific `docker-compose.yml` file and `.env` file containing the environment variables used to configure the container(s). Some containers may also need additional steps before they are ready for use.

### Docker stacks list

Below you will find the list of all the stacks used to provide the various services of my server. For each stack you will have a description of its purpose as well as how to deploy and use the stack.

#### Backbone

##### What it is

The "backbone" is the stack that is used to link and control all the others stacks. It is compose of 2 containers:

- [Traefik](https://traefik.io/) is used as the reverse proxy for all the other stacks. It will automatically (or well, thanks to configuration) detect new containers that should be exposed to the Internet and will forward them as well as generate new SSL certificates for them using Let's Encrypt.
- [Portainer](https://www.portainer.io/) is optional but is a nice addition that offers a GUI to list and controls the various stacks and containers. I most often use it to access the logs of the containers when debug is needed, as well as to input manual commands inside the containers.

##### How to use

There are 3 environment variables that you should configure in the `.env` file:

1. <u>DOCKER_DIRECTORY</u> is the directory used to store the fast changing files of each container. As such, it should **not** point to a directory inside the **SnapRAID backed disk** as such fast changing files won't play nice with the parity snapshots of SnapRAID.
2. <u>LETSENCRYPT_EMAIL</u> is the email used when creating the Let's Encrypt certificates.
3. <u>TRAEFIK_DASHBOARD_HTPASSWORD</u> is the username and password used to access the Traefik dashboard (through basic authentication). You can use a generator for it such as [this one](https://wtools.io/generate-htpasswd-online).

Once you have changed those environment variables, start the stack with

```
docker-compose up -d
```

Once it is done, you should be able to connect to the Traefik dashboard at `routing.<your_domain>`. You should also go to `docker.<your_domain>` to configure Portainer for first time use.