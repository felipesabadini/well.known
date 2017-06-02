#!/bin/bash

service tomcat stop
sleep 100

java -jar /root/well-known-0.0.1-SNAPSHOT-jar-with-dependencies.jar &
sleep 100

./certbot-auto certonly --quiet --webroot -w /root/gumgafiles --agree-tos --email gumgait@gmail.com -d gumga.studio -d www.gumga.studio
sleep 100

openssl pkcs12 -export -in /etc/letsencrypt/live/gumga.studio/fullchain.pem -inkey /etc/letsencrypt/live/gumga.studio/privkey.pem -out /etc/letsencrypt/live/gumga.studio/pkcs.p12 -name tomcat -passin pass:qwe123qwe -passout pass:qwe123qwe
sleep 100

keytool -importkeystore -deststorepass qwe123qwe -destkeypass qwe123qwe -destkeystore /etc/letsencrypt/live/gumga.studio/MyDSKeyStore.jks -srckeystore /etc/letsencrypt/live/gumga.studio/pkcs.p12 -srcstoretype PKCS12 -srcstorepass qwe123qwe -alias tomcat
sleep 100

cp /etc/letsencrypt/live/gumga.studio/MyDSKeyStore.jks certificado-https/.keystore
sleep 100

service tomcat start