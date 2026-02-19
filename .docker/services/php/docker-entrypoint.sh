#!/bin/bash
set -e

# . Handle the PHP-FPM socket directory (from your zzz-www.conf)
mkdir -p /var/run/php-fpm
chown -R www-data:www-data /var/run/php-fpm
chmod -R 755 /var/run/php-fpm

# . Create and fix Laravel storage/framework subdirectories
# These are essential for Laravel to boot correctly
mkdir -p /var/www/bootstrap/cache \
         /var/www/storage \
         /var/www/tests/Browser/{console,screenshots}

# . Fix Ownership for the entire storage and bootstrap folders
# Because we synced IDs in the Dockerfile, www-data = You
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache /var/www/tests/Browser
chmod -R 775 /var/www/storage /var/www/bootstrap/cache /var/www/tests/Browser

if [ ! -d "/var/www/vendor" ]; then
    su-exec www-data composer install --no-interaction --no-ansi --no-scripts
fi

# . Fix Ownership for vendor if it exists (safety net)
chown -R www-data:www-data /var/www/vendor
chmod -R 755 /var/www/vendor

# We do this as www-data to ensure the link is owned correctly
su-exec www-data php /var/www/artisan storage:link --force

su-exec www-data php /var/www/artisan optimize:clear

# Execute the CMD (php-fpm)
exec "$@"
