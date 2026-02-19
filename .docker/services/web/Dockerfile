FROM node:20.19.0-alpine AS node
FROM nginx:1.26-alpine

ENV TZ=UTC

# Build arguments from your x-common-build anchor
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apk update && \
    apk add --no-cache \
    libstdc++ libgcc g++ python3 libmagic \
    bash shadow su-exec

# Remap nginx UID/GID to match your PC user
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    userdel -f nginx && \
    groupadd -g ${GROUP_ID} nginx && \
    useradd -l -m -u ${USER_ID} -g nginx nginx \
;fi

# Ensure /home/nginx is fully owned by the new user
RUN mkdir -p /home/nginx/.npm && chown -R nginx:nginx /home/nginx
ENV HOME=/home/nginx

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

# node command
COPY --from=node /usr/local/bin /usr/local/bin
# npm command
COPY --from=node /usr/local/lib /usr/local/lib

ARG DOCKER_SERVICES_PATH
COPY ${DOCKER_SERVICES_PATH}/web/conf.d/domain.conf /etc/nginx/conf.d/default.conf
COPY ${DOCKER_SERVICES_PATH}/web/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN npm install -g npm@11.6.4 && npm cache clean --force

RUN chown -R nginx:nginx /home/nginx/.npm

WORKDIR /var/www

# Web container handles its own permissions
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
