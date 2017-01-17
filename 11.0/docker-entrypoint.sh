#!/bin/sh

echo >&2 "Setting Permissions:"
path='/nextcloud'
htuser='www-data'
CONFIGFILE=/config/config.php

sed -i "s|##UPLOAD_MAX_SIZE##|${UPLOAD_MAX_SIZE}|g" /etc/php7/php-fpm.conf
sed -i "s|##APC_SHM_SIZE##|${APC_SHM_SIZE}|g" /etc/php7/conf.d/apcu.ini
sed -i "s/##OPCACHE_MEM_SIZE##/${OPCACHE_MEM_SIZE}/g" /etc/php7/conf.d/00_opcache.ini

ln -sf /config/config.php /nextcloud/config/config.php &>/dev/null
ln -sf /apps2 /nextcloud &>/dev/null

if [ ! -f /config/config.php ]; then
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

cat > /nextcloud/config/autoconfig.php <<EOF;
<?php
\$AUTOCONFIG = array (
  # storage/database
  'directory'     => '/data',
  'dbtype'        => '${DB_TYPE:-sqlite3}',
  'dbname'        => '${DB_NAME:-nextcloud}',
  'dbuser'        => '${DB_USER:-nextcloud}',
  'dbpass'        => '${DB_PASSWORD:-password}',
  'dbhost'        => '${DB_HOST:-nextcloud-db}',
  'dbtableprefix' => 'oc_',
EOF
if [[ ! -z "$ADMIN_USER"  ]]; then
  cat >> /nextcloud/config/autoconfig.php <<EOF;
  # create an administrator account with a random password so that
  # the user does not have to enter anything on first load of ownCloud
  'adminlogin'    => '${ADMIN_USER}',
  'adminpass'     => '${ADMIN_PASSWORD}',
EOF
fi
cat >> /nextcloud/config/autoconfig.php <<EOF;
);
?>
EOF

    echo "Starting automatic configuration..."
    (cd /nextcloud; php7 index.php)
    echo "Automatic configuration finished."
else
    occ upgrade
    if [ \( $? -ne 0 \) -a \( $? -ne 3 \) ]; then
        echo "Trying ownCloud upgrade again to work around ownCloud upgrade bug..."
        occ upgrade
        if [ \( $? -ne 0 \) -a \( $? -ne 3 \) ]; then exit 1; fi
        occ maintenance:mode --off
        echo "...which seemed to work."
    fi
fi

chown -R ${htuser}:${htuser} /data
chown -R ${htuser}:${htuser} /config
chown -R ${htuser}:${htuser} /apps2
chown -R ${htuser}:${htuser} /nextcloud

exec "$@"
