#!/bin/bash

SSLMARIAIP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' sslmaria)

docker run -it --rm -w /home -v $PWD:/home --name mariaclient --link sslmaria:mysql mariadb \
mysql -h"$SSLMARIAIP" -P3306 -uiamsecure -piamsecurepwd \
--ssl-ca=/home/ca-cert-2/ca-cert-2.pem --ssl-cert=/home/client-cert-2/client-cert-2.pem \
--ssl-key=/home/client-private-2/client-private-key-rsa-2.pem
