FROM php:8-fpm-alpine

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

RUN apk add zip unzip curl libpng-dev
RUN apk add nodejs npm

RUN apk --update add wget \
    curl \
    git \
    grep \
    build-base \
    libmemcached-dev \
    libmcrypt-dev \
    libxml2-dev \
    imagemagick-dev \
    pcre-dev \
    libtool \
    make \
    autoconf \
    g++ \
    cyrus-sasl-dev \
    libgsasl-dev \
    php-mbstring \
    icu-dev 

RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN docker-php-ext-install pdo pdo_mysql xml bcmath

RUN rm /var/cache/apk/* 

# Install SUPERVISOR

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && pecl install redis && docker-php-ext-enable redis \
    &&  rm -rf /tmp/*

RUN apk add supervisor
ADD ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
