#!/bin/bash

mkdir /etc/ocserv/ssl/ 

read -p "Enter Your organization: " ORGANIZATION_NAME
read -p "Enter certificate owner: " CERTIFICATE_OWNER
read -p "Enter certificate serial number: " SERIAL_NUMBER
read -p "Enter expiration date (Use -1 if there is no expiration date): " EXP

cd /etc/ocserv/ssl/

certtool --generate-privkey --outfile ${ORGANIZATION_NAME}-ca-privkey.pem

cat > /etc/ocserv/ssl/ca-cert.cfg << EOF
organization = "${ORGANIZATION_NAME}"
cn = "${CERTIFICATE_OWNER}"
serial = ${SERIAL_NUMBER}
expiration_days = ${EXP}
ca
signing_key
cert_signing_key
crl_signing_key
EOF

certtool --generate-self-signed --load-privkey ${ORGANIZATION_NAME}-ca-privkey.pem --template ca-cert.cfg --outfile ${ORGANIZATION_NAME}-ca-cert.pem