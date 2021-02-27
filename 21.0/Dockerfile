FROM alpine:3
LABEL maintainer="alain.knaebel@aknaebel.fr"

ENV NEXTCLOUD_VERSION=21.0.0
ENV UPLOAD_MAX_SIZE=10G
ENV APC_SHM_SIZE=128M
ENV OPCACHE_MEM_SIZE=128
ENV DB_TYPE=sqlite3
ENV ADMIN_USER=admin
ENV ADMIN_PASSWORD=password

RUN BUILD_DEPS="gnupg build-base autoconf automake libtool samba-dev pcre-dev" \
 && apk --no-cache add ca-certificates openssl \
      php8-fpm php8 php8-ctype php8-dom php8-gd php8-iconv php8-json php8-xml php8-mbstring php8-posix php8-zip php8-zlib php8-xmlwriter php8-simplexml \
      php8-bcmath php8-calendar php8-dba php8-gettext php8-phar php8-shmop php8-soap php8-sockets php8-sysvmsg php8-sysvshm php8-sysvshm php8-xmlreader \
      php8-sqlite3 php8-pdo_sqlite php8-pdo_mysql php8-pgsql \
      php8-curl php8-bz2 php8-intl php8-pecl-mcrypt php8-openssl \
      php8-ldap php8-ftp php8-imap \
      php8-exif php8-gmp php8-pecl-imagick \
      php8-pecl-igbinary php8-pecl-memcached php8-redis php8-pecl-apcu \
      ffmpeg php8-pcntl php8-fileinfo \
      wget unzip libsmbclient samba-client su-exec \
      php8-opcache php8-pear php8-dev tar ${BUILD_DEPS} \
 && sed -i "$ s|\-n||g" /usr/bin/pecl8 \
 && pecl8 channel-update pecl.php.net \
 && pecl8 install smbclient \
 && echo "extension=smbclient.so" > /etc/php8/conf.d/00_smbclient.ini \
 && echo "date.timezone = 'UTC'" >> /etc/php8/php.ini \
 && echo "short_open_tag = 0" >> /etc/php8/php.ini \
 && sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php8/php.ini \
 && addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -G www-data www-data \
 && mkdir /nextcloud /apps2 /config /data \
 && NEXTCLOUD_TARBALL="nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" \
 && cd /tmp && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL} \
 && tar xjf ${NEXTCLOUD_TARBALL} --strip 1 -C /nextcloud \
 && chown -R www-data:www-data /nextcloud \
 && apk del ${BUILD_DEPS} php8-pear php8-dev \
 && rm -rf /var/cache/apk/* /tmp/*

COPY ./php-fpm.conf /etc/php8/php-fpm.conf
COPY ./opcache.ini /etc/php8/conf.d/00_opcache.ini
COPY ./apcu.ini /etc/php8/conf.d/apcu.ini

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./occ /usr/local/bin/occ

VOLUME /nextcloud
VOLUME /data
VOLUME /config
VOLUME /apps2

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm8"]
