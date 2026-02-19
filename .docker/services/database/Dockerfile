FROM mariadb:10.6

ENV TZ=UTC

ARG DOCKER_SERVICES_PATH
COPY ${DOCKER_SERVICES_PATH}/database/my.cnf /etc/mysql/conf.d/my.cnf

RUN chmod 644 /etc/mysql/conf.d/my.cnf
