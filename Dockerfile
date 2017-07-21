FROM sameersbn/ubuntu:14.04.20170123
MAINTAINER sameer@damagehead.com
ENV MYSQL_USER=mysql \
MYSQL_DATA_DIR=/var/lib/mysql \
MYSQL_RUN_DIR=/run/mysqld \
MYSQL_LOG_DIR=/var/log/mysql
RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
&& rm -rf ${MYSQL_DATA_DIR} \
&& rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ADD my_init.d/Jiradb.sql /etc/Jiradb.sql
RUN chmod +x /etc/Jiradb.sql

ADD script/custom.sh /etc/custom.sh
RUN chmod +x /etc/custom.sh

EXPOSE 3306/tcp
VOLUME ["${MYSQL_DATA_DIR}", "${MYSQL_RUN_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/bin/mysqld_safe"]
