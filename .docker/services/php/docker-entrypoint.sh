#!/bin/bash
set -e

echo "--- Preparing environment ---"

# --- 1. Directory Preparation ---
mkdir -p /var/run/php-fpm \
         /composer/cache/files \
         /var/www/bootstrap/cache \
         /var/www/public \
         /var/www/storage \
         /var/www/storage/framework/{sessions,views,cache} \
         /var/www/storage/logs

# --- 2. Targeted Permissions Management ---
chown -R www-data:www-data /composer \
                           /var/run/php-fpm \
                           /var/www/public \
                           /var/www/storage \
                           /var/www/bootstrap \
                           /var/www/bootstrap/cache \
                           /var/www/vendor 2>/dev/null || true

chmod -R 775 /composer \
             /var/www/storage \
             /var/www/bootstrap/cache

chmod 775 /var/run/php-fpm

if [ -d "/var/www/bootstrap/cache" ]; then
    find /var/www/bootstrap/cache -type f ! -name '.gitignore' -delete
fi

# --- 4. Composer Build Pipeline ---
if [ -f "/var/www/composer.json" ]; then
    # Run install only if vendor is missing
    if [ ! -d "/var/www/vendor/autoload.php" ]; then
        echo "Vendor directory not found. Installing dependencies..."
        su-exec www-data composer install --no-interaction
    fi

    # Safety check: Ensure vendor ownership is correct
    chown -R www-data:www-data /var/www/vendor
    chmod -R 755 /var/www/vendor

    # Run artisan commands
    su-exec www-data php /var/www/artisan storage:link --force
    if ! grep -qE '^APP_KEY=base64:' /var/www/.env 2>/dev/null && [ -z "$APP_KEY" ]; then
        su-exec www-data php /var/www/artisan key:generate --force
    fi
    su-exec www-data php /var/www/artisan optimize:clear
    su-exec www-data php /var/www/artisan migrate --force
else
    echo "Notice: composer.json not found in /var/www. Skipping Composer tasks."
fi

# Execute the CMD
exec "$@"
