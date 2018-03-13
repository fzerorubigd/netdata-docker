FROM alpine:latest
MAINTAINER fzerorubigd<fzero@rubi.gd>

ADD entrypoint.sh /entrypoint
COPY netdata /netdata

RUN apk update \
    && apk add alpine-sdk autoconf automake curl gcc git libmnl-dev make \
            netcat-openbsd pkgconfig py-yaml python util-linux-dev zlib-dev \
            bash go py-mysqldb build-base libuuid postfix mailx\
    && addgroup -g 1000 netdata \
    && adduser -D -H -u 1000 -G netdata netdata \
    && git clone https://github.com/firehol/netdata.git /netdata.git \
    && cd /netdata.git \
    && ./netdata-installer.sh --dont-wait --dont-start-it \
    && cd / && rm -rf /netdata.git \
    && GOPATH=/tmp GOBIN=/bin go get github.com/fzerorubigd/iniset \
    && rm -rf /tmp/* \
    && apk del alpine-sdk autoconf automake gcc make pkgconfig go \
            pkgconf zlib-dev util-linux-dev libmnl-dev g++ build-base git \
    && ln -sf /dev/stdout /var/log/netdata/access.log \
    && ln -sf /dev/stdout /var/log/netdata/debug.log \
    && ln -sf /dev/stderr /var/log/netdata/error.log \
    && chmod a+x /entrypoint \
    && chown -R netdata:netdata /etc/netdata

USER netdata

ENTRYPOINT ["/entrypoint"]
