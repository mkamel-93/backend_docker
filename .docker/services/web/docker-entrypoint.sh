#!/bin/bash
set -e

# --- 1. Directory Preparation ---
mkdir -p /home/nginx/.npm \
         /var/www/public/build \
         /var/www/storage/logs

# --- 2. Targeted Permissions Management ---
chown -R nginx:nginx /home/nginx/.npm \
                     /var/www/public/build \
                     /var/www/node_modules 2>/dev/null || true

chmod -R 775 /home/nginx/.npm \
             /var/www/public/build

# --- 3. Log File Initialization ---
touch /var/www/.docker/logs/nginx-backend-error.log
chown nginx:nginx /var/www/.docker/logs/nginx-backend-error.log
chmod 664 /var/www/.docker/logs/nginx-backend-error.log

# --- 4. Node.js Build Pipeline ---
if [ -f "package.json" ]; then
    # This will not crash even if the file is already gone
    rm -f /var/www/public/hot

    # Install dependencies only if the node_modules folder is missing
    if [ ! -d "/var/www/node_modules" ]; then
        echo "node_modules not found. Installing..."
        su-exec nginx npm install
        chown -R nginx:nginx /var/www/node_modules
    fi

    # Run the production build
    echo "Running build..."
    su-exec nginx npm run build
else
    echo "Notice: package.json not found in /var/www. Skipping Node tasks."
fi

# --- 5. Start Container Process ---
# Pass execution to the CMD defined in the Dockerfile (e.g., nginx)
exec "$@"
