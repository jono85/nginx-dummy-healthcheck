#!/bin/sh

echo ""
echo "Starting customized nginx..."
echo ""

if [ $DUMMY_SERVER_SSL_PORT -gt 0  ]
then
	echo "DUMMY_SERVER_SSL_PORT configured to $DUMMY_SERVER_SSL_PORT, configuring SSL..."
	echo "Copying template..."
	cp /app/conf/default-with-ssl-template.conf /etc/nginx/conf.d/default.conf
	echo "Setting SSL listening port in template"
	sed -i -e 's;'"SSL_LISTENING_PORT_PLACEHOLDER"';'"$DUMMY_SERVER_SSL_PORT"';g' /etc/nginx/conf.d/default.conf
	echo "Copying self signed certificate and key"
	cp /app/certs/dummy.crt /etc/nginx/dummy.crt
	cp /app/certs/dummy.key /etc/nginx/dummy.key
else
	echo "DUMMY_SERVER_SSL_PORT is 0, SSL will remain disabled and only port 80 will be open"
	cp /app/conf/default-no-ssl.conf /etc/nginx/conf.d/default.conf
fi

echo "Removing all existing files in html dir"
rm -rf /usr/share/nginx/html/*
rm -rf /usr/share/nginx/html/*.*


echo "All finished, starging nginx process..."

# /bin/sh
# nginx #this runs nginx in the background and container will exit
nginx -g 'daemon off;'  #run nginx in foreground for the container not to exit