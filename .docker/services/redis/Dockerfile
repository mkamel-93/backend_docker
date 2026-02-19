FROM redis:5.0.3-alpine

ENV TZ=UTC

ARG DOCKER_SERVICES_PATH
COPY ${DOCKER_SERVICES_PATH}/redis/redis.conf /usr/local/etc/redis/redis.conf

CMD [ "redis-server" , "/usr/local/etc/redis/redis.conf"]
