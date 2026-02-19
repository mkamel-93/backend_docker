FROM php:8.2.30-fpm-alpine

ENV TZ=UTC

# These receive the values from docker-compose
ARG USER_ID=1000
ARG GROUP_ID=1000

# System Utilities & Shell
RUN apk add --no-cache \
    bash \
    shadow \
    su-exec \
    curl \
    supervisor \
    unzip \
    zip

# Remap www-data UID/GID to match your PC user
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    userdel -f www-data && \
    if getent group www-data ; then groupdel www-data; fi && \
    groupadd -g ${GROUP_ID} www-data && \
    useradd -l -u ${USER_ID} -g www-data www-data && \
    install -d -m 0755 -o www-data -g www-data /home/www-data \
;fi


# Build Tools (Needed for PECL/Compiling)
RUN apk add --no-cache \
    autoconf \
    build-base \
    linux-headers

# Image & Graphics Libraries
RUN apk add --no-cache \
    freetype-dev \
    imagemagick-dev \
    jpeg-dev \
    libpng-dev

# Database & Core PHP Dependencies
RUN apk add --no-cache \
    curl-dev \
    icu-dev \
    libxml2-dev \
    libzip-dev \
    oniguruma-dev \
    openldap-dev \
    sqlite-dev \
    sqlite

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    ftp \
    gd \
    intl \
    mysqli \
    pdo_mysql \
    pdo_sqlite \
    zip

RUN printf "\n" | pecl install imagick xdebug \
    && docker-php-ext-enable imagick xdebug \
    && rm -rf /tmp/pear

ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/composer
COPY --from=composer:2.8.12 /usr/bin/composer /usr/bin/composer

RUN mkdir -p /composer/cache && chown -R www-data:www-data /composer

ARG DOCKER_SERVICES_PATH
COPY ${DOCKER_SERVICES_PATH}/php/php-fpm.d/zzz-www.conf /usr/local/etc/php-fpm.d/zzz-www.conf
COPY ${DOCKER_SERVICES_PATH}/php/php.ini /usr/local/etc/php/php.ini
COPY ${DOCKER_SERVICES_PATH}/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
