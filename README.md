# docker-nextcloud

## Description:

This docker image provide a [nextcloud](https://nextcloud.com/) service based on [Alpine Linux edge](https://hub.docker.com/_/alpine/) using php7-fpm

## Tags:

- latest: Lastest stable version (15.0)
- 15.0 : latest 14.0.x version (stable)
- 14.0 : latest 14.0.x version (old stable)
- 13.0 : latest 13.0.x version (old old stable)
- 12.0 : latest 12.0.x version (unsupported)
- 11.0 : latest 11.0.x version (unsupported)
- 10.0 : latest 10.0.x version (unsupported)

## Usage:
```
docker run -d --name mariadb \
-v /nextcloud/db:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=root_password \
-e MYSQL_DATABASE=nextcloud  \
-e MYSQL_USER=nextcloud \
-e MYSQL_PASSWORD=nextcloud_password \
mariadb

docker run --name nextcloud -d -p 9000:9000 \
--link mariadb:mariadb
-v /nextcloud/data:/data \
-v /nextcloud/config:/config \
-v /nextcloud/apps2:/apps2 \
-e UPLOAD_MAX_SIZE=10G \
-e APC_SHM_SIZE=128M \
-e OPCACHE_MEM_SIZE=128 \
-e ADMIN_USER=admin \
-e ADMIN_PASSWORD=admin_password \
-e DB_TYPE=mysql \
-e DB_NAME=nextcloud \
-e DB_USER=nextcloud \
-e DB_PASSWORD=nextcloud_password \
-e DB_HOST=mariadb
-e TRUSTED_DOMAIN=nextcloud.example.com
--restart=always aknaebel/nextcloud
```

## Docker-compose:
``` 
version: '2'
services:
    mariadb:
        image: mariadb
        volumes:
            - /nextcloud/db:/var/lib/mysql
        environment:
            - MYSQL_ROOT_PASSWORD=root_password
            - MYSQL_DATABASE=nextcloud
            - MYSQL_USER=nextcloud
            - MYSQL_PASSWORD=nextcloud_password

    nextcloud:
        image: aknaebel/nextcloud
        ports:
            - "9000:9000"
        links:
           - mariadb
        volumes:
            - /nextcloud/data:/data
            - /nextcloud/config:/config
            - /nextcloud/apps2:/apps
        environment:
            - UPLOAD_MAX_SIZE=10G
            - APC_SHM_SIZE=128M
            - OPCACHE_MEM_SIZE=128
            - ADMIN_USER=admin \
            - ADMIN_PASSWORD=admin_password \
            - DB_TYPE=mysql \
            - DB_NAME=nextcloud \
            - DB_USER=nextcloud \
            - DB_PASSWORD=nextcloud_password \
            - DB_HOST=mariadb
            - TRUSTED_DOMAIN=nextcloud.example.com
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
- ADMIN_USER : username of the admin account (default : admin)
- ADMIN_PASSWORD : password of the admin account (default : password)
- DB_TYPE : database type (sqlite3, mysql or pgsql) (default : sqlite3)
- DB_NAME : name of database (default : none)
- DB_USER : username for database (default : none)
- DB_PASSWORD : password for database user (default : none)
- DB_HOST : database host (default : none)
- TRUSTED_DOMAIN: first authorize trusted domain after installation (default: localhost)

### Features:

The image come with all the PHP's extensions supported by nextcloud to provide a fully operationnal instance.

See the [official documentation](https://docs.nextcloud.com/) to configure a specific option of your nextcloud instance.
