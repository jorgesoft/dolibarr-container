# Use an official PHP runtime as a parent image
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install additional dependencies
RUN apt-get update && apt-get install -y \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        graphviz \
        nano \
        unzip \
        curl \
        git \
        libc-client-dev \
        libkrb5-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli opcache intl zip calendar imap

# Get the specified version of Dolibarr
ARG DOLIBARR_VERSION=19.0.0
RUN curl -o dolibarr.zip -SL https://github.com/Dolibarr/dolibarr/archive/refs/tags/${DOLIBARR_VERSION}.zip \
    && unzip dolibarr.zip -d /usr/src/ \
    && mv /usr/src/dolibarr-${DOLIBARR_VERSION}/htdocs/* /var/www/html \
    && rm dolibarr.zip \
    && chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Run Apache in foreground
CMD ["apache2-foreground"]
