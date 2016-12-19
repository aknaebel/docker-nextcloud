#!/bin/sh

echo >&2 "Setting Permissions:"
#path='/var/www/nextcloud'
path='/nextcloud'
htuser='www-data'
CONFIGFILE=/config/config.php

sed -i "s|##UPLOAD_MAX_SIZE##|${UPLOAD_MAX_SIZE}|g" /etc/php7/php-fpm.conf
sed -i "s|##APC_SHM_SIZE##|${APC_SHM_SIZE}|g" /etc/php7/conf.d/apcu.ini
sed -i "s/##OPCACHE_MEM_SIZE##/${OPCACHE_MEM_SIZE}/g" /etc/php7/conf.d/00_opcache.ini

ln -sf /config/config.php /nextcloud/config/config.php &>/dev/null
ln -sf /apps2 /nextcloud &>/dev/null

if [ "$(ls -A ${path}/config)" ]; then
    instanceid=oc$(echo $PRIMARY_HOSTNAME | sha1sum | fold -w 10 | head -n 1)
    cat > $CONFIGFILE <<EOF;
<?php
\$CONFIG = array (
  'datadirectory' => '/data',
  "apps_paths" => array (
    0 => array (
          "path"     => "/nextcloud/apps",
          "url"      => "/apps",
          "writable" => false,
    ),
    1 => array (
          "path"     => "/apps2",
          "url"      => "/apps2",
          "writable" => true,
    ),
  ),
 'instanceid' => '$instanceid',
);
EOF


    chown -R ${htuser}:${htuser} /data
    chown -R ${htuser}:${htuser} /config
    chown -R ${htuser}:${htuser} /apps2
    chown -R ${htuser}:${htuser} /nextcloud
else
    chown -R ${htuser}:${htuser} /data
    chown -R ${htuser}:${htuser} /config
    chown -R ${htuser}:${htuser} /apps2
    chown -R ${htuser}:${htuser} /nextcloud
fi

exec "$@"
