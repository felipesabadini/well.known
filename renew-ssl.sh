#!/bin/bash

service tomcat stop
sleep 100

java -jar /root/well-known-0.0.1-SNAPSHOT-jar-with-dependencies.jar &
sleep 100

/root/certbot-auto certonly --quiet --webroot -w /root/gumgafiles --agree-tos --email gumgait@gmail.com -d gumga.io -d www.gumga.io
sleep 100

openssl pkcs12 -export -in /etc/letsencrypt/live/gumga.io/fullchain.pem -inkey /etc/letsencrypt/live/gumga.io/privkey.pem -out /etc/letsencrypt/live/gumga.io/pkcs.p12 -name tomcat -passin pass:qwe123qwe -passout pass:qwe123qwe
sleep 100

keytool -importkeystore -deststorepass qwe123qwe -destkeypass qwe123qwe -destkeystore /etc/letsencrypt/live/gumga.io/MyDSKeyStore.jks -srckeystore /etc/letsencrypt/live/gumga.io/pkcs.p12 -srcstoretype PKCS12 -srcstorepass qwe123qwe -alias tomcat
sleep 100

cp /etc/letsencrypt/live/gumga.io/MyDSKeyStore.jks certificadoSSL/.keystore
sleep 100

service tomcat start