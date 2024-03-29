FROM php:7.4-fpm

LABEL Maintainer="Jeremy Brayton"

# apt-get required packages
RUN apt-get update -yqq && apt-get install -yqq git openssh-client libzip-dev zip unzip iputils-ping libicu-dev libxml2-dev

# PHP extension installation
RUN docker-php-ext-install pdo_mysql zip bcmath json pcntl posix intl soap

# Install iconv and gd
RUN apt-get install -yqq libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Install mcrypt
#RUN apt-get install -yqq libmcrypt-dev \
#    && pecl install -f mcrypt \
#    && docker-php-ext-enable mcrypt
# Unsure if the next part is necessary but it does say -> You should add "extension=mcrypt.so" to php.ini
#RUN echo "extension=mcrypt.so" > /usr/local/etc/php/conf.d/mcrypt.ini

# Install ssh2
#RUN apt-get install -yqq libssh2-1 libssh2-1-dev \
#    && pecl install ssh2 \
#    && docker-php-ext-enable ssh2

# Install xdebug
#RUN pecl install xdebug \
#    && docker-php-ext-enable xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1

# Environmental variables
ENV COMPOSER_HOME /root/.composer
ENV COMPOSER_CACHE_DIR /cache
ENV PATH /root/.composer/vendor/bin:$PATH

# Install composer parallel downloads
RUN composer global require "hirak/prestissimo:^0.3"

# Install deployer
RUN composer global require "deployer/deployer"
RUN composer global require --dev "deployer/recipes"

# Install PHP SSH2 extension
#RUN composer global require "herzult/php-ssh:~1.1"
