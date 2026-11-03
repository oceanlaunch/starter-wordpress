# WordPress on OceanLaunch: the official image, run as its unprivileged user (www-data) on port 8080, with the site in
# /data/wordpress (in the app's storage at /data, so uploads, themes, plugins and updates survive deploys) and the
# database OceanLaunch connects (DATABASE_URL). The first start copies WordPress there and writes wp-config.php with
# fresh keys.
FROM wordpress:7.1.4-php8.4-apache@sha256:50c808d213d038ad68fdbb8d9ecb35f8181a8670928dc669c1c4595f23b8bcf8

COPY oceanlaunch-db.php /usr/src/oceanlaunch-db.php
COPY oceanlaunch-start.sh /usr/local/bin/oceanlaunch-start.sh
RUN set -eux; \
    chmod 755 /usr/local/bin/oceanlaunch-start.sh; \
    sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf; \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/; s#/var/www/html#/data/wordpress#' /etc/apache2/sites-available/000-default.conf; \
    printf '<Directory /data/wordpress/>\n\tOptions FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>\n' \
        > /etc/apache2/conf-available/oceanlaunch.conf; \
    a2enconf oceanlaunch; \
    sed -i 's/^ServerTokens .*/ServerTokens Prod/; s/^ServerSignature .*/ServerSignature Off/' /etc/apache2/conf-available/security.conf; \
    grep -q '^ServerTokens Prod' /etc/apache2/conf-available/security.conf; \
    sed -i '1r /usr/src/oceanlaunch-db.php' /usr/src/wordpress/wp-config-docker.php; \
    grep -q DATABASE_URL /usr/src/wordpress/wp-config-docker.php; \
    printf '%s\n' 'upload_max_filesize = 64M' 'post_max_size = 64M' 'memory_limit = 256M' 'max_execution_time = 120' \
        'upload_tmp_dir = /var/tmp' 'sys_temp_dir = /var/tmp' 'expose_php = Off' > /usr/local/etc/php/conf.d/oceanlaunch.ini; \
    mkdir -p /data; \
    chown www-data:www-data /data

# Any WORDPRESS_ variable makes the first start write wp-config.php (from wp-config-docker.php, with the lines above).
ENV WORDPRESS_DB_CHARSET=utf8mb4
WORKDIR /data
USER www-data
EXPOSE 8080
ENTRYPOINT ["oceanlaunch-start.sh"]
CMD ["apache2-foreground"]
