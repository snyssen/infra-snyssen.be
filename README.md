# Infrastructure of snyssen.be
All the necessary instructions, docker files, scripts, etc. necessary for building my self hosted server (almost) from scratch.

## Requirements

Follow the [Bare Metal installation](https://perfectmediaserver.com/installation/manual-install/) instructions from the great tutorial/wiki of [Alex Kretzschmar](https://www.linkedin.com/in/alex-kretzschmar/), [Perfect Media Server](https://perfectmediaserver.com/). In the end, you should have :

- At least one parity disk for [SnapRaid](https://www.snapraid.it/). Parity disks naming scheme should follow `parity1`, `parity2`, etc.
- At least one storage HDD. storage disks should follow the naming scheme `disk1`, `disk2`, etc. and then be pooled by [MergerFS](https://github.com/trapexit/mergerfs) under `/mnt/storage`
- Optionally, one or more SSD for faster, shorter term storage. SSD should follow the naming scheme `ssd1`, `ssd2`, etc. and then be pooled under `/mnt/cache`
- Automatic `scrub` and `sync` for  [SnapRaid](https://www.snapraid.it/) using [snapraid-runner](https://github.com/Chronial/snapraid-runner)
- A valid docker and docker compose installation

A valid domain name is also necessary for this installation.

## Get Started

1. Clone this project locally by using `git clone https://github.com/snyssen/infra-snyssen.be.git` then go into it using `cd infra-snyssen.be`.
2. Fill environment file with the necessary info, you can use `nano .env`. You can see the list of variables [here](#environment-variables)
3. Save and exit with <kbd>ctrl</kbd>+<kbd>X</kbd>
4. Create the necessary folders and configuration files inside your `DOCKER_DIRECTORY` (see [environment variables](#environment-variables)) . the following directories will later be mounted inside the various containers in use :
   1. `mkdir -p portainer/data` for the [Portainer](https://www.portainer.io/) data
   2. `mkdir traefik` for [Traefik](https://traefik.io/)
   3. `touch traefik/acme.json` then `chmod 600 traefik/acme.json`. This is the certificate store for [Traefik](https://traefik.io/), it will hold all of the Let's Encrypt TLS certificates
   4. `mkdir -p jellyfin/config` then `mkdir jellyfin/cache` for the [Jellyfin](https://jellyfin.org/) configuration and cache
5. Run `docker-compose up -d` to start the containers

## environment variables

This is the environment variables defined inside the `.env` file.

- `LETSENCRYPT_EMAIL` : email address used for the Let's Encrypt SSL certificates
- `TRAEFIK_DASHBOARD_HTPASSWORD` : *.htpassword* encoded entry containing the username and hashed password to use to connect to the traefik dashboard (using basic auth). You can create your entry using [this tool](https://www.askapache.com/online-tools/htpasswd-generator/)
- `DOCKER_DIRECTORY` : directory in which the various docker volumes are mounted (outside actual data such as medias and documents)