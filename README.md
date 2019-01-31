## PHP CI Docker image

PHP Docker image for use with continous integration tools. It includes a standard set of tools and utilities for building and deploying PHP applications.

These are the additions to the original PHP 7.3 CLI image:

* VCS (git, mercurial, subversion)
* Composer (with prestissimo)
* Node.js
* Grunt, gulp
* SSH
* Ansible
* PHP extensions:
  * gd
  * gettext
  * intl
  * pdo_mysql
  * pdo_pgsql
  * pgsql
  * soap
  * xsl
  * zip
