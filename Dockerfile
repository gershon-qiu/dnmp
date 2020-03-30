ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

ARG TZ
ARG PHP_EXTENSIONS
ARG MORE_EXTENSIONS_INSTALL
ARG ALPINE_REPOSITORIES
ARG PHALCON_VERSION

RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories; \
    fi

RUN  apk --no-cache add tzdata \
        && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone

# Ensure UTF-8 locale
#COPY locale /etc/default/locale
#RUN locale-gen zh_CN.UTF-8 &&\
#  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
#RUN locale-gen zh_CN.UTF-8  
#ENV LANG zh_CN.UTF-8  
#ENV LANGUAGE zh_CN:zh  
#ENV LC_ALL zh_CN.UTF-8  


COPY ./conf/php/extensions /tmp/extensions
WORKDIR /tmp/extensions

ENV EXTENSIONS=",${PHP_EXTENSIONS},"
# ENV MC="-j$(nproc)"

RUN export MC="-j$(nproc)" \
        && chmod +x install.sh \
        && chmod +x "${MORE_EXTENSIONS_INSTALL}" \
        && sh install.sh \
        && sh "${MORE_EXTENSIONS_INSTALL}" \
        && rm -rf /tmp/extensions

WORKDIR /var/www/html