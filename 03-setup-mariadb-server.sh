#!/bin/bash

SERVERCONTAINER="sslmaria"
RUNNING=$(docker ps | grep -c $SERVERCONTAINER)
if [ $RUNNING -gt 0 ]; then
    docker rm -f $SERVERCONTAINER
    echo "$SERVERCONTAINER already exists and was removed."
else
    echo "No instance of $SERVERCONTAINER found."
fi

docker run --name sslmaria -v $PWD:/etc/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb \
--ssl-ca=/etc/mysql/ca-cert-1/ca-cert-1.pem --ssl-cert=/etc/mysql/server-cert-1/server-cert-1.pem \
--ssl-key=/etc/mysql/server-private-1/server-private-key-rsa-1.pem  --bind-address=*
