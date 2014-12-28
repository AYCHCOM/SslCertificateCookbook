#!/usr/bin/env bats

SSL_PATH='/etc'
DEB_PATH='/etc/ssl'
RH_PATH='/etc/pki/tls'

setup() {
  if [ -d "${DEB_PATH}" ]
  then
    SSL_PATH="${DEB_PATH}"
  elif [ -d "${RH_PATH}" ]
  then
    SSL_PATH="${RH_PATH}"
  fi
  CERT_PATH="${SSL_PATH}/certs"
}

@test "creates a non-SAN certificate" {
  [ -f "${CERT_PATH}/subject_alternate_names.pem" ]
}

@test "creates a SAN certificate" {
  [ -f "${CERT_PATH}/subject_alternate_names2.pem" ]
}

@test "the non-SAN certificate has no Subject Alternative Name line" {
  ! openssl x509 -in "${CERT_PATH}/subject_alternate_names.pem" -text -noout \
    | grep -F 'X509v3 Subject Alternative Name'
}

@test "the SAN certificate has a Subject Alternative Name line" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'X509v3 Subject Alternative Name'
}

@test "the SAN certificate has a DNS:foo entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:foo'
}

@test "the SAN certificate has a DNS:bar entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:bar'
}

@test "the SAN certificate has a DNS:subject-alternate-name entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:subject-alternate-name'
}

@test "the SAN certificate has a DNS:foo.subject-alternate-name entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:foo.subject-alternate-name'
}