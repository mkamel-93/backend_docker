FROM mariadb:10.6

ENV TZ=UTC

# Build arguments from your x-common-build anchor
ARG USER_ID=1000
ARG GROUP_ID=1000

# Remap mysql UID/GID to match your PC user
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    userdel -f mysql && \
    if getent group mysql ; then groupdel mysql; fi && \
    groupadd -g ${GROUP_ID} mysql && \
    useradd -l -m -u ${USER_ID} -g mysql mysql \
;fi

# Configuration
ARG DOCKER_SERVICES_PATH
COPY ${DOCKER_SERVICES_PATH}/database/my.cnf /etc/mysql/conf.d/my.cnf

RUN chmod 644 /etc/mysql/conf.d/my.cnf

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
  CMD mysqladmin ping -h localhost -u root -p"$MYSQL_ROOT_PASSWORD" || exit 1