#!/bin/sh

echo >&2 "Setting Permissions:"
path='/var/www/nextcloud'
htuser='www-data'

sed -i "s|##UPLOAD_MAX_SIZE##|${UPLOAD_MAX_SIZE}|g" /etc/php7/php-fpm.conf
sed -i "s|##APC_SHM_SIZE##|${APC_SHM_SIZE}|g" /etc/php7/conf.d/apcu.ini
sed -i "s/##OPCACHE_MEM_SIZE##/${OPCACHE_MEM_SIZE}/g" /etc/php7/conf.d/00_opcache.ini



if [ "$(ls -A ${path}/config)" ]; then
    chown -R ${htuser}:${htuser} ${path}/data
    chown -R ${htuser}:${htuser} ${path}/config
    chown -R ${htuser}:${htuser} ${path}/apps
else
    cp -R /nextcloud/apps/* ${path}/apps
    cp -R /nextcloud/config/* ${path}/config
    chown -R ${htuser}:${htuser} ${path}/data
    chown -R ${htuser}:${htuser} ${path}/config
    chown -R ${htuser}:${htuser} ${path}/apps
fi

exec "$@"
