FROM ubuntu:latest
MAINTAINER fzerorubigd<fzero@rubi.gd>

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get --yes install git wget curl autoconf autoconf-archive autogen automake golang bash \
    gcc libmnl-dev make netcat pkg-config python python-yaml uuid-dev zlib1g-dev sendmail python-mysqldb && \
    addgroup --gid 1000 netdata && \
    adduser --system --disabled-password --no-create-home --uid 1000 netdata && \
    git clone https://github.com/firehol/netdata.git /netdata.git && \
    cd /netdata.git && \
    ./netdata-installer.sh --dont-wait --dont-start-it && \
    cd / && rm -rf /netdata.git && \
    GOPATH=/tmp GOBIN=/bin go get github.com/fzerorubigd/iniset && \
    rm -rf /tmp/* && \
    ln -sf /dev/stdout /var/log/netdata/access.log && \
    ln -sf /dev/stdout /var/log/netdata/debug.log && \
    ln -sf /dev/stderr /var/log/netdata/error.log && \
    chmod a+x /entrypoint.sh && \
    chown netdata:netdata -R /etc/netdata

USER netdata

ENTRYPOINT ["/entrypoint.sh"]
