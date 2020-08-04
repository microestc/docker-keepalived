FROM debian:buster

COPY sources.list /etc/apt/sources.list
COPY docker-entrypoint.sh /entrypoint.sh
RUN apt-get update \
    && apt-get install -y keepalived ipset netcat \
    && chmod +x /entrypoint.sh \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]