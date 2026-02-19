#!/bin/bash
set -e

# . PHP-FPM Socket access
mkdir -p /var/run/php-fpm
chmod 755 /var/run/php-fpm

# . Ensure the shared log directory exists
# Nginx needs this to write 'nginx-backend-error.log'
mkdir -p /var/www/node_modules /var/www/public/build
chown -R nginx:nginx /var/www/storage/logs /var/www/public/build /home/nginx/.npm
chmod -R 775 /var/www/storage/logs /var/www/public/build /var/www/node_modules

# . Handle node_modules permission
if [ ! -d "/var/www/node_modules" ]; then
    su-exec nginx npm install
    chown -R nginx:nginx /var/www/node_modules
fi
su-exec nginx npm run build

# Execute Nginx
exec "$@"
