#!/bin/bash

#Create new user who needs client certifcate to authenticate.
docker exec sslmaria mysql -uroot -pmy-secret-pw \
-e "GRANT ALL PRIVILEGES ON *.* TO 'iamsecure'@'%' IDENTIFIED BY 'iamsecurepwd' REQUIRE X509;FLUSH PRIVILEGES;"

