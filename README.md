# docker-nextcloud

## Description:

This docker image provide a [nextcloud](https://nextcloud.com/) service based on [Alpine Linux edge](https://hub.docker.com/_/alpine/) using php7-fpm

## Tags:

- latest: Lastest stable version (11.0)
- 11.0 : latest 11.0.x version (stable)
- 10.0 : latest 10.0.x version (old stable)

## Usage:
```
docker run --name nextcloud -d -p 9000:9000 \
-v /nextcloud/data:/data \
-v /nextcloud/config:/config \
-v /nextcloud/apps2:/apps2 \
-e UPLOAD_MAX_SIZE=10G \
-e APC_SHM_SIZE=128M \
-e OPCACHE_MEM_SIZE=128 \
--restart=always aknaebel/nextcloud
```

## Docker-compose:
``` 
version: '2'
services:
    nextcloud:
        image: aknaebel/nextcloud
        ports:
            - "9000:9000"
        volumes:
            - /nextcloud/data:/data
            - /nextcloud/config:/config
            - /nextcloud/apps2:/apps
        environment:
            - UPLOAD_MAX_SIZE=10G
            - APC_SHM_SIZE=128M
            - OPCACHE_MEM_SIZE=128
        restart: always 
```

```
docker-compose up -d
```

## Nextcloud stuff:

### Environment variables:
- UPLOAD_MAX_SIZE : maximum upload size (default : 10G)
- APC_SHM_SIZE : apc memory size (default : 128M)
- OPCACHE_MEM_SIZE : opcache memory size in megabytes (default : 128)

### Features:

The image come with all the PHP's extensions supported by nextcloud to provide a fully operationnal instance.

See the [official documentation](https://docs.nextcloud.com/) to configure a specific option of your nextcloud instance.
