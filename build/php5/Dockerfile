FROM php:5.6-fpm
MAINTAINER shidongliang<shidongliang@me.com>

# Change Timezone
ENV TIME_ZONE Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

# Change APT SOURCES
COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libmemcached-dev \
        graphicsmagick \
        libgraphicsmagick1-dev \
        imagemagick \
        libmagickwand-dev \
        libssh2-1-dev \
        libzip-dev \
        libzookeeper-mt-dev \
        libldap2-dev \
        libssl-dev \
        libmosquitto-dev \
        librabbitmq-dev \
        inotify-tools \
        libevent-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) bcmath gd gettext pdo_mysql mysqli ldap pcntl soap sockets sysvsem xmlrpc mcrypt \
    && pecl install gmagick-1.1.7RC3 \
    && pecl install imagick-3.4.3 \
    && pecl install memcached-2.2.0 \
    && pecl install redis-4.0.2 \
    && pecl install mongodb-1.4.3 \
    && pecl install swoole-1.10.5 \
    && pecl install ssh2-0.13 \
    && pecl install zip-1.15.2 \
    && pecl install zookeeper-0.5.0 \
    && pecl install Mosquitto-0.4.0 \
    && pecl install amqp-1.9.3 \
    && pecl install inotify-2.0.0 \
    && pecl install event-2.3.0 \
    && docker-php-ext-enable gmagick memcached redis mongodb swoole ssh2 zip zookeeper mosquitto amqp inotify event \
    && apt-get clean \
    && apt-get autoremove --purge -y

# Install php composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer \
    && php -r "unlink('composer-setup.php');" \
    && composer config -g repo.packagist composer https://packagist.laravel-china.org

VOLUME /data

# Make dir
RUN mkdir -p /data/logs/srv/php

