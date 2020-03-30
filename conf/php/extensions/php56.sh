#!/bin/sh

echo
echo "============================================"
echo "Install extensions from   : ${MORE_EXTENSION_INSTALL}"
echo "PHP version               : ${PHP_VERSION}"
echo "Extra Extensions          : ${PHP_EXTENSIONS}"
echo "Multicore Compilation     : ${MC}"
echo "Work directory            : ${PWD}"
echo "============================================"
echo


if [ -z "${EXTENSIONS##*,yaml,*}" ]; then
    echo "---------- Install yaml ----------"
        apk add --no-cache yaml-dev \
        && pecl install yaml-1.3.2 \
        && docker-php-ext-enable yaml
fi

if [ -z "${EXTENSIONS##*,xdebug,*}" ]; then
       echo "---------- Install xdebug ----------"
       pecl install xdebug-2.5.5 \
       && docker-php-ext-enable xdebug
fi

if [ -z "${EXTENSIONS##*,memcached,*}" ]; then
    echo "---------- Install memcached ----------"
	apk add --no-cache libmemcached-dev zlib-dev \
     && pecl install memcache-2.2.7 \
     && pecl install memcached-2.2.0 \
     && docker-php-ext-enable memcache memcached
fi

if [ -z "${EXTENSIONS##*,phalcon,*}" ]; then
    echo "---------- Install phalcon ----------"
	#  curl -LO https://github.com/phalcon/cphalcon/archive/Dao-v1.3.6-Final.tar.gz && \
        tar -xf cphalcon-phalcon-v1.3.4.tar.gz \
        && cd ./cphalcon-phalcon-v1.3.4/build \
        && ./install \
        && docker-php-ext-enable phalcon
fi
