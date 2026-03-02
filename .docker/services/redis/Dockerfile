FROM redis:7.4-alpine

ENV TZ=UTC

ARG DOCKER_SERVICES_PATH
COPY ${DOCKER_SERVICES_PATH}/redis/redis.conf /usr/local/etc/redis/redis.conf

CMD [ "redis-server" , "/usr/local/etc/redis/redis.conf"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD redis-cli -a "$REDIS_PASSWORD" ping || exit 1
