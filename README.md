# Infrastructure of snyssen.be
All the necessary instructions, docker files, scripts, etc. necessary for building my self hosted server (almost) from scratch.

## Requirements

Follow the [Bare Metal installation](https://perfectmediaserver.com/installation/manual-install/) instructions from the great tutorial/wiki of [Alex Kretzschmar](https://www.linkedin.com/in/alex-kretzschmar/), [Perfect Media Server](https://perfectmediaserver.com/). In the end, you should have :

- At least one parity disk for [SnapRaid](https://www.snapraid.it/). Parity disk naming scheme should follow `parity1`, `parity2`, etc.
- At least one storage HDD. storage disks should follow the naming scheme `disk1`, `disk2`, etc. and then be pooled by [MergerFS](https://github.com/trapexit/mergerfs) under `/mnt/storage`
- Optionally, one or more SSD for faster, shorter term storage. SSD should follow the naming scheme `ssd1`, `ssd2`, etc. and then be pooled under `/mnt/cache`
- Automatic `scrub` and `sync` for  [SnapRaid](https://www.snapraid.it/) using [snapraid-runner](https://github.com/Chronial/snapraid-runner)
- A valid docker and docker compose installation

A valid domain name is also necessary for this installation.

## Get Started

First of all you should clone this repository locally by using `git clone https://github.com/snyssen/infra-snyssen.be.git`

### Docker backbone

The docker backbone hosts the [Traefik](https://traefik.io/) reverse-proxy that all our web services will use to access the outside world, as well the [Portainer](https://www.portainer.io/) instance that will give us an overview of all of our later docker instances

1. Go into the backbone folder with `cd infra-snyssen.be/docker-backbone`
2. Fill environment file with the necessary info, you can use `nano .env`
3. Save and exit with <kbd>ctrl</kbd>+<kbd>X</kbd>
4. Create the necessary folders and config files :
   1. `mkdir /mnt/storage/DOCKER`, it will contain all the docker config related mounts
   2. `mkdir /mnt/storage/DOCKER/portainer` then `mkdir /mnt/storage/DOCKER/portainer/data` for the [Portainer](https://www.portainer.io/) data
   3. `mkdir /mnt/storage/DOCKER/traefik` for [Traefik](https://traefik.io/)
   4. `touch /mn/storage/DOCKER/traefik/acme.json` then `chmod 600 /mn/storage/DOCKER/traefik/acme.json`. This is the certificate store for [Traefik](https://traefik.io/), it will hold all of the Let's Encrypt TLS certificates
5. Run `docker-compose up -d docker-backbone` to run the backbone