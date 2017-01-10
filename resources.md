---
layout: page
title: Resources
permalink: /resources
---

Useful DEVOPS Technology, Tools and Know-How
============================================

* [Monitoring](#monitoring)
* [Development](#development)
   * [Java](#java)
* [Platforms](#platforms)
   * [Platform Tools](#platform-tools)
   * [Kubernetes](#kubernetes)
* [SSL Related Stuff](#ssl-related-stuff)
   * [Order of certificates in the bundle (.pem) file](#order-of-certificates-in-the-bundle-pem-file)
   * [Display all certificates in bundle (.pem) file](#display-all-certificates-in-bundle-pem-file)
   * [Show certificate expiration date with s_client](#show-certificate-expiration-date-with-s_client)
   * [One-Stop-Shop: Generating root CA cert and signing a cert with openssl](#one-stop-shop-generating-root-ca-cert-and-signing-a-cert-with-openssl)
   * [Generating 4096 bits RSA key](#generating-4096-bits-rsa-key)
   * [Generating ECDSA key](#generating-ecdsa-key)
   * [PKI / CA Tools](#pki--ca-tools)
* [Web Development](#web-development)
   * [Design resources](#design-resources)
   * [JavaScript](#javascript)


## Monitoring
* [Prometheus](https://github.com/prometheus/blackbox_exporter)
* [Prometheus Blackbox exporter -  allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP](https://github.com/prometheus/blackbox_exporter)
* [Prometheus Node exporter - exporter for machine metrics](https://github.com/prometheus/node_exporter)
* [Prometheus haproxy exporter](https://github.com/prometheus/haproxy_exporter)
* [Prometheus memcached exporter](https://github.com/prometheus/memcached_exporter)


## Development

* [Google Protocol Buffers](https://developers.google.com/protocol-buffers/)
* [ProtoBuf for Go](https://github.com/golang/protobuf)

### Java

* [Spring Boot](https://projects.spring.io/spring-boot/)

## Platforms

* [Shippable - A declarative CI/CD pipeline for the Modern IT](https://app.shippable.com)
* [StackPoint - The Universal Control Plane for Kubernetes](https://api.stackpoint.io)

### Platform Tools

* [Cloud Platform Benchmarks](https://github.com/GoogleCloudPlatform/PerfKitBenchmarker)
* [ElasticSearch Web Admin](https://github.com/lmenezes/elasticsearch-kopf)

### Kubernetes

* [etcd cluster setup and recovery](https://github.com/coreos/etcd-operator)


## SSL Related Stuff

### Order of certificates in the bundle (.pem) file

Per [RFC4346](http://tools.ietf.org/html/rfc4346#section-7.4.2) the certs should placed in the chain file:
* starting with the issued cert
* any intermediate certificates in the signing order
* rootCA at the end of file.

> certificate_list
>    This is a sequence (chain) of X.509v3 certificates.  The sender's
>    certificate must come first in the list.  Each following
>    certificate must directly certify the one preceding it.  Because
>    certificate validation requires that root keys be distributed
>    independently, the self-signed certificate that specifies the root
>    certificate authority may optionally be omitted from the chain,
>    under the assumption that the remote end must already possess it
>    in order to validate it in any case.

### Display all certificates in bundle (.pem) file

```
$ openssl crl2pkcs7 -nocrl -certfile CHAINED.pem | openssl pkcs7 -print_certs -text -noout
```

### Show certificate expiration date with s_client

```
echo | openssl s_client -connect <HOST>:<PORT> 2>/dev/null | openssl x509 -noout -dates
```

### One-Stop-Shop: Generating root CA cert and signing a cert with openssl

root CA without password:

```
openssl req -new -newkey rsa:4096 -days 3650 -x509 -nodes -subj "/C=PL/O=Lab CA Org/CN=Lab CA" -keyout CA.key -out CA.crt
```

root CA with password:

```
openssl req -new -newkey rsa:4096 -days 3650 -x509 -subj "/C=PL/O=Lab CA Org/CN=Lab CA" -keyout CA.key -out CA.crt
```

Generating KEY and CSR (without passphrase for Apache/Nginx):

```
openssl req -new -newkey rsa:4096 -nodes -subj "/C=PL/O=Client Org/CN=server-cert" -keyout server.key -out server.csr
```

Sign for TLS Server usage, valid for 1 year:

```
openssl x509 -req -in server.csr -CA CA.crt -CAkey CA.key -CAcreateserial -CAserial serial.txt -out server.crt -days 365 -extfile ext-tls-server
```

Sign for TLS Client usage, valid for 1 year:

```
openssl x509 -req -in server.csr -CA CA.crt -CAkey CA.key -CAcreateserial -CAserial serial.txt -out server.crt -days 365 -extfile ext-tls-client
```

Extension files:

ext-tls-client:

```
basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth 
```

ext-tls-server:

```
basicConstraints = CA:FALSE
nsCertType = server
nsComment = "OpenSSL Generated Server Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
```

email encryption:

```
basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = emailProtection
```

### Generating 4096 bits RSA key 
```
$ openssl req \
    -new \
    -newkey rsa:4096 \
    -nodes \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout certificate.key \
    -out certificate.csr
```

### Generating ECDSA key 

```
$ openssl req \
    -new \
    -newkey ec \
    -pkeyopt ec_paramgen_curve:prime256v1 \
    -nodes \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout certificate.key \
    -out certificate.csr
```

Notes:
* -nodes option means that the key will not be secured with a passphrase
* -x509 option can be used if you wish to create a self-signed certificate

### PKI / CA Tools

* [Lemur manages TLS certificate creation.](https://github.com/Netflix/lemur)
* [BLESS - SSH Certificate Authority](https://github.com/Netflix/bless)
* [CFSSL](https://github.com/cloudflare/cfssl) - CloudFoundry's PKI and TLS toolkit


## Web Development

### Design resources

* [https://html5up.net](https://html5up.net) - Nice HTML5 ready made designs 

### JavaScript

* [The Reactive Extensions for JavaScript (RxJS) 4.0](https://github.com/Reactive-Extensions/RxJS)

