FROM alpine:3.6

MAINTAINER Carl St-Laurent <carl@carlstlaurent.com>

LABEL caddy_version="0.10.7" architecture="amd64"

ARG plugins=http.cache,http.cors,http.filter,http.forwardproxy,http.grpc,http.ipfilter,http.nobots,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,tls.dns.cloudflare

RUN apk add --no-cache openssh-client git tar curl

RUN curl --silent --show-error --fail --location \
    --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
    "https://caddyserver.com/download/linux/amd64?plugins=${plugins}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && /usr/bin/caddy -version

EXPOSE 80 443 9180
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]