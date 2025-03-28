FROM php:fpm-alpine3.21
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
RUN delgroup dialout

# Install prerequisites for PHP and extensions
RUN apk update && apk add --no-cache git zip postgresql17-dev sqlite-dev mariadb-dev pcre-dev autoconf make libzip-dev libffi-dev zstd-dev
RUN docker-php-ext-install pdo zip pdo_pgsql pdo_mysql pdo_sqlite opcache ffi
RUN pecl install --force zstd && rm -rf /tmp/pear
RUN pecl install --configureoptions='enable-redis-zstd="yes"' --force redis && rm -rf /tmp/pear
RUN docker-php-ext-enable redis zstd

# Set up PHP-FPM to create a UNIX socket file instead of listening through TCP to remove all TCP overheads
RUN sed -i 's/listen = 127.0.0.1:9000/listen = \/run\/php-fpm.sock/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/;listen.backlog = 511/listen.backlog = -1/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/;listen.owner = www-data/listen.owner = www-data/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/;listen.group = www-data/listen.group = www-data/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/;listen.mode = 0660/listen.mode = 0777/' /usr/local/etc/php-fpm.d/www.conf

# Remove the needless zz-docker.conf file
RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf

# Create a crontabs file for www-data user.
RUN touch /etc/crontabs/www-data
RUN chown www-data:www-data /etc/crontabs/www-data
RUN chmod +rw /etc/crontabs/www-data

# Run the PHP-FPM daemon
CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-F", "-R"]