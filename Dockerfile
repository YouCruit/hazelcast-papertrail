FROM hazelcast/hazelcast:3.11.2
ENV TINI_SHA1="d1cb5d71adc01d47e302ea439d70c79bd0864288"
ENV TINI_URL="https://github.com/krallin/tini/releases/download/v0.16.1/tini-static-amd64"

RUN	apk update \
    && apk add rsyslog \
    && wget -nv -O /usr/local/bin/tini $TINI_URL \
    && sha1sum /usr/local/bin/tini \
    && echo "$TINI_SHA1  /usr/local/bin/tini" | sha1sum -cw \
    && chmod a+rx /usr/local/bin/tini \
    && rm -rf /var/cache/apk/* \
    && rm /etc/rsyslog.conf

ADD	rsyslog.conf /etc/rsyslog.conf
ADD papertrail-bundle.pem /etc/ssl/papertrail-bundle.pem
ADD start.sh /start.sh

EXPOSE 514

CMD	["/usr/local/bin/tini", "/start.sh"]
