#!/bin/sh

echo "STARTUP: Starting customized nginx dummy"


echo "STARTUP: Variable DUMMY_SERVER_PORT = $DUMMY_SERVER_PORT"
if [ $DUMMY_SERVER_PORT -gt 0 ]
then
	echo "" >>/dev/null
else
	echo "   WARN: Port invalid, going to use a random port number instead."
	RANDPORT=$RANDOM$RANDOM
	export DUMMY_SERVER_PORT=$(($RANDPORT%10000+50000))
fi
echo "STARTUP: Non-SSL connections will listen on port $DUMMY_SERVER_PORT"


echo "STARTUP: Variable DUMMY_SERVER_SSL_PORT = $DUMMY_SERVER_SSL_PORT"
if [ $DUMMY_SERVER_SSL_PORT -gt 0  ]
then
	echo "" >>/dev/null
else
	echo "   WARN: SSL port invalid, going to use a random port number instead."
	RANDPORTSSL=$RANDOM$RANDOM
	export DUMMY_SERVER_SSL_PORT=$(($RANDPORTSSL%10000+50000))
fi
echo "STARTUP: SSL connections will listen on port $DUMMY_SERVER_SSL_PORT"


echo "STARTUP: Copying config template"
cp /app/conf/default-with-ssl-template.conf /etc/nginx/conf.d/default.conf
echo "STARTUP: Setting non-SSL listener to port $DUMMY_SERVER_PORT"
sed -i -e 's;'"NON_SSL_LISTENING_PORT_PLACEHOLDER"';'"$DUMMY_SERVER_PORT"';g' /etc/nginx/conf.d/default.conf

echo "STARTUP: Configuring SSL"
echo "STARTUP: Setting SSL listener to port $DUMMY_SERVER_SSL_PORT"
sed -i -e 's;'"SSL_LISTENING_PORT_PLACEHOLDER"';'"$DUMMY_SERVER_SSL_PORT"';g' /etc/nginx/conf.d/default.conf
echo "STARTUP: Copying self signed certificate and key"
cp /app/certs/dummy.crt /etc/nginx/dummy.crt
cp /app/certs/dummy.key /etc/nginx/dummy.key


echo "STARTUP: Removing all existing files in html dir"
rm -rf /usr/share/nginx/html/*
rm -rf /usr/share/nginx/html/*.*


echo "STARTUP: All finished, starting nginx process"

# nginx #this runs nginx in the background and container will exit
nginx -g 'daemon off;'  #run nginx in foreground for the container not to exit
