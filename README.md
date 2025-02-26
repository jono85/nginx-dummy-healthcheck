# nginx-dummy-healthcheck
Dummy nginx container that will listen on dynamic port to respond to EC2 load balancer healthchecks, based on minimal image nginx:alpine.

Will listen for both non-SSL and SSL connections.
SSL uses a self-signed certificate valid until 2035.

Listener ports are configrable via enviro variables:
- DUMMY_SERVER_PORT
- DUMMY_SERVER_SSL_PORT

If no value is set in the variables, random ports in range 50000-60000 will be assigned to allow the container to start.


Example docker run command to listen on ports 80 and 443:
```
#!/bin/bash

CONTAINER_IMAGE='jono85/nginx-dummy-healthcheck:latest'
CONTAINER_NAME='nginxdummy'

NON_SSL_PORT=80
SSL_PORT=443

docker run \
	--name $CONTAINER_NAME \
	--hostname $CONTAINER_NAME \
	-p $NON_SSL_PORT:$NON_SSL_PORT \
	-p $SSL_PORT:$SSL_PORT \
	-e DUMMY_SERVER_PORT=$NON_SSL_PORT \
	-e DUMMY_SERVER_SSL_PORT=$SSL_PORT \
	$CONTAINER_IMAGE
```