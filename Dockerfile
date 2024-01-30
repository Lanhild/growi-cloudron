FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN mkdir -p /app/code/growi
WORKDIR /app/code/growi

ENV NODE_ENV=production

ARG VERSION=6.2.6

RUN wget https://github.com/weseek/growi/archive/refs/tags/v${VERSION}.tar.gz -O - | \
    tar -xz --strip-components 1 -C /app/code/growi

RUN yarn --ignore-engines add turbo node-gyp -W && \
    yarn --ignore-engines turbo prune --scope=@growi/app --docker && \
    yarn --ignore-engines install && \
    yarn --ignore-engines run app:build && \
    rm -rf node_modules/.cache .yarn/cache apps/app/.next/cache

COPY start.sh /app/pkg/

CMD ["/app/pkg/start.sh"]
