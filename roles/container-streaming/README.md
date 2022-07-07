# A note on the directory structure

The directory structured follows the recommendations from the [servarr team](https://wiki.servarr.com/docker-guide#consistent-and-well-planned-paths) and [this guide](https://trash-guides.info/Hardlinks/How-to-setup-for/Docker/).

## Server structure

```txt
/mnt/storage/streaming
├── torrent
│  ├── movies
│  ├── music
│  └── tv
├── usenet
│  ├── movies
│  ├── music
│  └── tv
└── media
   ├── movies
   ├── music
   └── tv
```

## Internal docker structure

### torrents

```txt
/data
└── torrent
   ├── movies
   ├── music
   └── tv
```

### usenet

```txt
/data
└── usenet
   ├── movies
   ├── music
   └── tv
```

### servarr apps

```txt
/data
├── torrent
│  ├── movies
│  ├── music
│  └── tv
├── usenet
│  ├── movies
│  ├── music
│  └── tv
└── media
   ├── movies
   ├── music
   └── tv
```

### Jellyfin

```txt
/data
└── media
   ├── movies
   ├── music
   └── tv
```

## Configurations

In addition, configurations are stored at `/mnt/storage/{name of service}/config` so they can be backed up easily.
