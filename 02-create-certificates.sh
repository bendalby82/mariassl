#!/bin/bash

mkdir -p ca-private
mkdir -p ca-cert
mkdir -p server-private
mkdir -p server-cert
mkdir -p client-private
mkdir -p client-cert

#Step 1: Generate CA private key
if [ ! -f $PWD/ca-private/ca-private-key.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl genrsa -out /home/ca-private/ca-private-key.pem 2048
    echo 'Step 1: CA private key created'
else
    echo 'Step 1: CA private key already exists'
fi

#Step 2: Generate CA certificate using the private key
if [ ! -f $PWD/ca-cert/ca-cert.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl req -sha1 -new -x509 -nodes -days 3650 -key /home/ca-private/ca-private-key.pem \
    -out /home/ca-cert/ca-cert.pem -subj "/C=GB/ST=Greater London/L=London/O=Dell EMC/OU=AWG/CN=awg.dell.com"
    echo 'Step 2: CA certificate created'
else
    echo 'Step 2: CA certificate already exists'
fi

#Step 3: Generate private server key and signing request
if [ ! -f $PWD/server-private/server-private-key.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl req -sha1 -newkey rsa:2048 -days 730 -nodes -keyout /home/server-private/server-private-key.pem \
    -out /home/server-private/server-key-signing-req.pem -subj "/C=GB/ST=Greater London/L=London/O=Dell EMC/OU=AWG/CN=mysql.awg.dell.com"
    echo 'Step 3: Private server key and signing request created'
else
    echo 'Step 3: Private server key already exists'
fi

#Step 4: Export private server key to RSA private key
if [ ! -f $PWD/server-private/server-private-key-rsa.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl rsa -in /home/server-private/server-private-key.pem -out /home/server-private/server-private-key-rsa.pem
    echo 'Step 4: Private server key expoerted to RSA format'
else
    echo 'Step 4: Private server key already exists in RSA format'
fi

#Step 5: Create server certificate based on server signing request
if [ ! -f $PWD/server-cert/server-cert.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl x509 -sha1 -req -in /home/server-private/server-key-signing-req.pem \
    -days 730  -CA /home/ca-cert/ca-cert.pem -CAkey /home/ca-private/ca-private-key.pem -set_serial 01 -out /home/server-cert/server-cert.pem
    echo 'Step 5: Server certificate created.'
else
    echo 'Step 5: Server certificate already exists.'
fi

#Step 6: Create private client key and signing request
if [ ! -f $PWD/client-private/client-private-key.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl req -sha1 -newkey rsa:2048 -days 730 -nodes \
    -keyout /home/client-private/client-private-key.pem -out /home/client-private/client-key-signing-req.pem \
    -subj "/C=GB/ST=Greater London/L=London/O=Dell EMC/OU=AWG/CN=client.awg.dell.com"
    echo 'Step 6: Client private key and signing request created.'
else
    echo 'Step 6: Client server key already exists'
fi

#Step 7: Export private client key to RSA private key
if [ ! -f $PWD/client-private/client-private-key-rsa.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl rsa -in /home/client-private/client-private-key.pem \
    -out /home/client-private/client-private-key-rsa.pem
    echo 'Step 7: Private client key exported to RSA format'
else
    echo 'Step 7: Private client key already exists in RSA format'
fi

#Step 8: Sign client certificate:w
if [ ! -f $PWD/client-cert/client-cert.pem ]; then
    docker run --rm -it -w /home -v $PWD:/home svagi/openssl x509 -sha1 -req -in /home/client-private/client-key-signing-req.pem \
    -days 730 -CA /home/ca-cert/ca-cert.pem -CAkey /home/ca-private/ca-private-key.pem -set_serial 01 -out /home/client-cert/client-cert.pem
    echo 'Step 8: Client certificate created'
else
    echo 'Step 8: Client certificate already exists'
fi




