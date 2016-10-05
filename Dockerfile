FROM php:5.6-fpm

MAINTAINER Jeremy Brayton <jeremy@braytonium.com>

# Set COMPOSER_HOME environment variable
ENV COMPOSER_HOME /cache/composer

# apt-get required packages
RUN apt-get update -yqq && apt-get install -yqq git zlib1g-dev

# PHP extension installation
RUN docker-php-ext-install pdo_mysql zip

# Install xdebug
#RUN pecl install xdebug \
#    && docker-php-ext-enable xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install composer parallel downloads
RUN composer global require "hirak/prestissimo:^0.3"

# Install deployer
RUN composer global require "deployer/deployer:~3.3"
RUN composer global require "deployphp/recipes:~3.1"
