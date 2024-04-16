#!/bin/bash
set -eu

echo "=> Creating directories"
mkdir -p /run/growi/nextcache

if [[ ! -f /app/data/.password_seed ]]; then
    echo "==> Create password seed"
    openssl rand -base64 32 > /app/data/.password_seed
fi
export PASSWORD_SEED=$(cat /app/data/.password_seed)

if [[ ! -f /app/data/env.sh ]]; then
    cat > /app/data/env.sh << EOF
# Add custom environment variables in this file

EOF
fi

# environment variables that cannot be overriden
export APP_SITE_URL="$CLOUDRON_APP_ORIGIN"
export FILE_UPLOAD="mongodb"
export MONGO_URI="$CLOUDRON_MONGODB_URL"
export PASSWORD_SEED="$PASSWORD_SEED"

source /app/data/env.sh

echo "==> Database migration"
cd /app/code/apps/app && yarn migrate

echo "==> Changing ownership"
chown -R cloudron:cloudron /app/data /run/growi

echo "==> Starting GROWI"
cd /app/code/apps/app && exec gosu cloudron:cloudron yarn server