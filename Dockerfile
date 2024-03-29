FROM php:8.1-cli-bullseye

LABEL maintainer="klemen.bratec@gmail.com"

# Install utilities and prerequisites
RUN DEBIAN_FRONTEND=noninteractive && \
    mkdir -p /usr/share/man/man1 && \
    mkdir -p /usr/share/man/man7 && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl vim nano bzip2 wget unzip default-mysql-client apt-utils apt-transport-https gettext && \
    apt-get install -y --no-install-recommends git subversion ssh && \
    apt-get install -y --no-install-recommends python3 python3-pip python3-setuptools python3-wheel python3-dev && \
    apt-get install -y --no-install-recommends postgresql-client && \
    apt-get install -y --no-install-recommends build-essential g++ gcc make autoconf pkg-config gnupg dirmngr && \
    apt-get install -y --no-install-recommends libfreetype6-dev libc-dev libcurl4-openssl-dev libzip-dev libmcrypt-dev libxml2-dev libonig-dev && \
    apt-get install -y --no-install-recommends libicu-dev libpcre3-dev libgd-dev libxslt-dev libpq-dev libgmp-dev libffi-dev && \
    apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install ansible requests google-auth

# Install PHP extensions
RUN docker-php-ext-install soap && \
    docker-php-ext-install zip && \
    docker-php-ext-install xsl && \
    docker-php-ext-install gettext && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install pdo_pgsql && \
    docker-php-ext-install pgsql && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install intl && \
    docker-php-ext-install gmp && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH ~/.composer/vendor/bin/:$PATH
RUN curl -s https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install PHPUnit
RUN composer global require "phpunit/phpunit=9.*"

# Install Node.js
RUN VERSION=node_16.x && \
    curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/$VERSION bullseye main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/$VERSION bullseye main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g npm@latest
