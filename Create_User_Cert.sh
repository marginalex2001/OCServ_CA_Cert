#!/bin/bash
mkdir /etc/ocserv/ssl/user-cert/
cd /etc/ocserv/ssl/

read -p "Enter Your organization: " ORGANIZATION_NAME
read -p "Enter username: " USERNAME
read -p "Enter common name of the certificate owner: " NAME
read -p "Enter expiration date (Use -1 if there is no expiration date): " EXP

mkdir /etc/ocserv/ssl/user-cert/${USERNAME}/
certtool --generate-privkey --outfile user-cert/${USERNAME}/${USERNAME}-privkey.pem

cat > /etc/ocserv/ssl/client-cert.cfg << EOF
organization = "${ORGANIZATION_NAME}"
cn = "${NAME}"
uid = "${USERNAME}"
expiration_days = ${EXP}
tls_www_client
signing_key
encryption_key
EOF

certtool --generate-certificate --load-privkey user-cert/${USERNAME}/${USERNAME}-privkey.pem --load-ca-certificate ${ORGANIZATION_NAME}-ca-cert.pem --load-ca-privkey ${ORGANIZATION_NAME}-ca-privkey.pem --template client-cert.cfg --outfile user-cert/${USERNAME}/${USERNAME}-cert.pem

if [ "$1" = "-A" ]; then
    certtool --to-p12 --load-privkey user-cert/${USERNAME}/${USERNAME}-privkey.pem --load-certificate user-cert/${USERNAME}/${USERNAME}-cert.pem --pkcs-cipher 3des-pkcs12 --outfile user-cert/${USERNAME}/${USERNAME}.p12 --outder
else
    certtool --to-p12 --load-privkey user-cert/${USERNAME}/${USERNAME}-privkey.pem --load-certificate user-cert/${USERNAME}/${USERNAME}-cert.pem --pkcs-cipher aes-256 --outfile user-cert/${USERNAME}/${USERNAME}.p12 --outder
fi

