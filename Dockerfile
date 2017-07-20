FROM dockerfile/ubuntu

RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
rm -rf /var/lib/apt/lists/* && \
sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
echo "mysqld_safe &" > /tmp/config && \
echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
bash /tmp/config && \
rm -f /tmp/config

VOLUME ["/etc/mysql", "/var/lib/mysql"]

WORKDIR /data

CMD ["mysqld_safe"]

EXPOSE 3306
