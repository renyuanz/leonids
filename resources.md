---
layout: page
title: Resources
permalink: /resources
---

## Useful DEVOPS Technology, Tools and Know-How

### Monitoring
* [Prometheus](https://github.com/prometheus/blackbox_exporter)
* [Prometheus Blackbox exporter -  allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP](https://github.com/prometheus/blackbox_exporter)
* [Prometheus Node exporter - exporter for machine metrics](https://github.com/prometheus/node_exporter)
* [Prometheus haproxy exporter](https://github.com/prometheus/haproxy_exporter)
* [Prometheus memcached exporter](https://github.com/prometheus/memcached_exporter)


### Development

* [Google Protocol Buffers](https://developers.google.com/protocol-buffers/)
* [ProtoBuf for Go](https://github.com/golang/protobuf)

### Platforms

* [Shippable - A declarative CI/CD pipeline for the Modern IT](https://app.shippable.com)
* [StackPoint - The Universal Control Plane for Kubernetes](https://api.stackpoint.io)

#### Platform Tools

* [Cloud Platform Benchmarks](https://github.com/GoogleCloudPlatform/PerfKitBenchmarker)

### Java

* [Spring Boot](https://projects.spring.io/spring-boot/)

### PKI / CA

* [Lemur manages TLS certificate creation.](https://github.com/Netflix/lemur)
* [BLESS - SSH Certificate Authority](https://github.com/Netflix/bless)
* [CFSSL] - CloudFoundry's PKI and TLS toolkit

### Kubernetes

* 

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



## Web Development

### Design resources

* https://html5up.net/
* 

