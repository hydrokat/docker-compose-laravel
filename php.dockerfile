FROM php:8-fpm-alpine

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql

# Install SUPERVISOR

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && pecl install redis && docker-php-ext-enable redis \
    &&  rm -rf /tmp/*

RUN apk add supervisor
ADD ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]