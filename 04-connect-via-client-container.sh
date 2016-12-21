#!/bin/bash

SSLMARIAIP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' sslmaria)

docker run -it --rm -w /home -v $PWD:/home --name mariaclient --link sslmaria:mysql mariadb \
mysql -h"$SSLMARIAIP" -P3306 -uiamsecure -piamsecurepwd \
--ssl-ca=/home/ca-cert/ca-cert.pem --ssl-cert=/home/client-cert/client-cert.pem \
--ssl-key=/home/client-private/client-private-key-rsa.pem