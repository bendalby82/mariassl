# Maria SSL
Demonstrates working SSL configuration for Maria DB, including client certificate authentication

# Overview  
This demonstration uses an [Alpine-based OpenSSL container](https://hub.docker.com/r/svagi/openssl/) to create a new Certificate Authority, and then uses that CA to create and sign server and client certificates. These certificates are then used to create an SSL-enabled server instance of [Maria DB](https://hub.docker.com/_/mariadb/), and a demonstration user with the [REQUIRE X509](https://dev.mysql.com/doc/refman/5.7/en/create-user.html) setting. A separate ephemeral Maria DB container is then spawned, and a client connection is opened to the server, using the demonstration user.  
  
# Dependencies  
Docker (tested on version 1.12.3)  
  
# Instructions for Use  
  
## Setup  
Run the four scripts in this repository in order.  
**01-pull-containers.sh**  
Pulls the latest OpenSSL and MariaDB containers.  
  
**02-create-certificates.sh**  
Creates keys and certificates.  
  
**03-setup-mariadb-server.sh**  
Creates a new container running Maria DB.
  
**04-create-test-user.sh**  
Creates a new user who must connect securely.  

**05-connect-via-client-container.sh**  
Creates a new ephemeral container running Maria DB, and connects to the server using `mysql`.

## Usage  
Type `\s` at the MySQL command prompt after running 04-connect-via-client-container.sh to verify SSL is being used.  
