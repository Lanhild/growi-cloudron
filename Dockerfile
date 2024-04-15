# ARG needs to be defined prior the first FROM statement if used in any FROM statement
ARG VERSION=7.0.1

FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4 AS base

FROM weseek/growi:${VERSION} AS growi

FROM base AS runner

ENV NODE_ENV production
WORKDIR /app/code

COPY --from=growi ./app ./opt/growi/apps/app/

COPY supervisor/* /etc/supervisor/conf.d/
RUN ln -sf /run/growi/supervisord.log /var/log/supervisor/supervisord.log

RUN ln -s /run/growi/nextcache /app/code/app/.next/cache

COPY start.sh /app/pkg/

RUN chmod +x /app/pkg/start.sh

CMD ["/app/pkg/start.sh"]
