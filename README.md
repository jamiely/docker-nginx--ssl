nginx-ssl
=========

A container image that has SSL-enabled by default, useful for testing
purposes.

* 80 - HTTP
* 443 - HTTPS, self-signed certificate

Examples
========

Make nginx accessible on https://localhost:8443 using a self-signed
certificate.

```bash
docker run -p 8443:443 jamiely/nginx-ssl
```

Use your own certificates:

```bash
% ls ssl
server.pem.crt key.pem root_CA_cert_plus_intermediates.pem.crt
% docker run -v $(pwd)/ssl:/etc/nginx/ssl jamiely/nginx-ssl
```

Change the common name (CN) associated with the self-signed certificate.

```bash
docker run -e COMMON_NAME=mine.example.com \
  -p 8443:443 jamiely/nginx-ssl
```

Change the subject alternative name (SAN) associated with the self-signed
certificate as well.

```bash
docker run -e COMMON_NAME=mine.example.com \
  -e SUBJECT_ALTERNATIVE_NAME=DNS:mine.example.com \
  -p 8443:443 jamiely/nginx-ssl
```

Check out setup_ssl.sh for more environment variables.
