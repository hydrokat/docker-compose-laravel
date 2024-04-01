FROM dunglas/frankenphp

RUN install-php-extensions \
  pcntl \
  pdo \
  pdo_mysql \
  xml \
  bcmath \
  redis

COPY ./src /app

WORKDIR /app

ENTRYPOINT ["php", "artisan", "octane:frankenphp", "--port=9000", "--max-requests=1", "--workers=1"]