# docker-jackett

[![](https://images.microbadger.com/badges/version/twanislas/jackett.svg)](https://github.com/Twanislas/docker-jackett/releases) [![](https://images.microbadger.com/badges/commit/twanislas/jackett.svg)](https://github.com/Twanislas/docker-jackett) [![](https://images.microbadger.com/badges/image/twanislas/jackett.svg)](https://microbadger.com/images/twanislas/jackett)  [![](https://img.shields.io/docker/pulls/twanislas/jackett.svg)](https://hub.docker.com/r/twanislas/jackett/) [![](https://img.shields.io/docker/stars/twanislas/jackett.svg)](https://hub.docker.com/r/twanislas/jackett/)

Docker container for [Jackett](https://github.com/Jackett/Jackett), based on latest Alpine Linux

Jackett works as a proxy server: it translates queries from apps (Sonarr, Radarr, SickRage, CouchPotato, Mylar, etc) into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.

# Usage
```sh
docker run \
-d \
--name jackett \
-e JACKETT_UID=<user id> \
-e JACKETT_GID=<group id> \
-p 9117:9117/tcp \
-v <path/to/jackett/config>:/config \
-v <path/to/data/folder>:/data \
twanislas/jackett
```

## Parameters
- `-e JACKETT_UID=<user id>` The user id of the `jackett` user created inside the container. This will default to `2000` if you don't set it.
- `-e JACKETT_GID=<group id>` The group id of the `jackett` group created inside the container. This will default to `2000` if you don't set it.
- `-p <host port>:<container port>` Forwards ports from the host to the container.
  - `9117` Web interface port.
- `-v <path/to/jackett/config>:/config` This is the path where you want to store Jackett's configuration
- `-v <path/to/data/folder>:/data` This is the path where Jackett can download torrents while doing a manual search. Also known as "blackhole" folder Ideally, this folder would be monitored by your download client.
