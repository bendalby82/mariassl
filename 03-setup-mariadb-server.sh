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
--ssl-ca=/etc/mysql/ca-cert/ca-cert.pem --ssl-cert=/etc/mysql/server-cert/server-cert.pem \
--ssl-key=/etc/mysql/server-private/server-private-key-rsa.pem  --bind-address=*
