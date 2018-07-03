FROM php:7.2-cli-stretch

LABEL maintainer="klemen.bratec@gmail.com"

# Install utilities and prerequisites
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl vim nano bzip2 wget unzip mysql-client sqlite apt-utils apt-transport-https gettext && \
    apt-get install -y --no-install-recommends git subversion mercurial ssh && \
    apt-get install -y --no-install-recommends build-essential g++ gcc make autoconf pkg-config gnupg dirmngr && \
    apt-get install -y --no-install-recommends libfreetype6-dev libc-dev libcurl4-openssl-dev libmcrypt-dev libxml2-dev libicu-dev libpcre3-dev libgd-dev libxslt-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install soap && \
    docker-php-ext-install zip && \
    docker-php-ext-install xsl && \
    docker-php-ext-install gettext && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install intl && \
    docker-php-ext-install gd

# Install Composer along with prestissimo
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH ~/.composer/vendor/bin/:$PATH
RUN curl -s https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer global require hirak/prestissimo

# Install PHPUnit
RUN composer global require "phpunit/phpunit=7.*"

# Install Node.js along with gulp and grunt
RUN VERSION=node_9.x && \
    curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/$VERSION stretch main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/$VERSION stretch main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g npm@latest gulp grunt

# Install Ansible
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee /etc/apt/sources.list.d/ansible.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
    apt-get update && \
    apt-get install -y --no-install-recommends ansible && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
