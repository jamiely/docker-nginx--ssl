FROM nginx:1.19

RUN mkdir -p /etc/nginx/ssl

COPY nginx_default.conf /etc/nginx/conf.d/default.conf

# Scripts in this directory get executed when the container starts up
COPY setup_ssl.sh /docker-entrypoint.d/30-setup_ssl.sh
