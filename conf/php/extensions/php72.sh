#!/bin/sh

 
# yaml xdebug memcached phalcon 

echo
echo "============================================"
echo "Install extensions from   : ${MORE_EXTENSIONS_INSTALL}"
echo "PHP version               : ${PHP_VERSION}"
echo "Extra Extensions          : ${PHP_EXTENSIONS}"
echo "Multicore Compilation     : ${MC}"
echo "Work directory            : ${PWD}"
echo "============================================"
echo
# extension dir path
extDir="$(php -d 'display_errors=stderr' -r 'echo ini_get("extension_dir");')"

if [ -z "${EXTENSIONS##*,yaml,*}" ]; then
    echo "---------- Install yaml ----------"
        apk add --no-cache yaml-dev \
        && pecl install yaml-2.0.4 \
        && docker-php-ext-enable yaml
fi

if [ -z "${EXTENSIONS##*,xdebug,*}" ]; then
       echo "---------- Install xdebug ----------"
       pecl install xdebug-2.7.2 \
       && docker-php-ext-enable xdebug
fi

# && pecl install memcache-3.0.8 \
if [ -z "${EXTENSIONS##*,memcached,*}" ]; then
    echo "---------- Install memcached ----------"
	apk add --no-cache libmemcached-dev zlib-dev \
     && pecl install memcached-3.1.3 \
     && docker-php-ext-enable memcached
fi


if [ -z "${EXTENSIONS##*,phalcon,*}" ]; then
    echo "---------- Install phalcon ----------"
    # build phalcon.so is too long time
    # Not the first build,could move file phalcon.so(rename phalcon-{PHALCON_VERSION}.so)  to extensions folder
    if [ -e "phalcon-${PHALCON_VERSION}.so"  ]; then
        echo "phalcon-${PHALCON_VERSION}.so"
         cp phalcon-${PHALCON_VERSION}.so $extDir/phalcon.so \
         && docker-php-ext-enable phalcon
        break
    else

        if [ ! -e "cphalcon-${PHALCON_VERSION}.tar.gz" ]; then
            curl -SfLO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
            && mv cphalcon-${PHALCON_VERSION}.tar.gz
        fi
        tar -xf cphalcon-${PHALCON_VERSION}.tar.gz \
        && cd ./cphalcon-${PHALCON_VERSION}/build \
        && ./install \
        && docker-php-ext-enable phalcon \
        && cp /$extDir/phalcon.so ${{SOURCE_DIR}}/conf/php/extensions/phalcon.so
    fi
fi

