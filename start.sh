#!/bin/bash
set -eu

echo "=> Creating directories"
mkdir -p /app/data/ /run/growi /run/yarn /run/cache/

if [[ ! -f /app/data/.password_seed ]]; then
    echo "==> Create password seed"
    openssl rand -base64 32 > /app/data/.password_seed
fi

if [[ ! -f /app/data/env ]]; then
    cat > /app/data/env << EOF
# Add custom environment variables in this file

APP_SITE_URL="https://${CLOUDRON_APP_DOMAIN}"
FILE_UPLOAD="local"
EOF
fi

export MONGO_URI="${CLOUDRON_MONGODB_URL}"
export PASSWORD_SEED="$(cat /app/data/.password_seed)"

echo "=> Merge cloudron and custom configs"
cat /app/data/env > /run/growi/.env
cat >> /run/growi/.env << EOF
APP_SITE_URL="https://${CLOUDRON_APP_DOMAIN}"
PASSWORD_SEED="${PASSWORD_SEED}"
MONGO_URI="${CLOUDRON_MONGODB_URL}"
FILE_UPLOAD="local"
EOF

echo "=> Copying web app to writable location /run/growi"
cp -R /app/code/growi/out/full/* /run/growi/

echo "==> Starting GROWI"
cd /run/growi
exec yarn start --no-daemon
