#!/bin/sh -eux

papertrailHost="${PAPERTRAIL%%:*}"
papertrailPort="${PAPERTRAIL##*:}"

echo "Logging to $papertrailHost:$papertrailPort"
sed -e "s/PAPERTRAIL_HOST/$papertrailHost/g" -e "s/PAPERTRAIL_PORT/$papertrailPort/g" -i /etc/rsyslog.conf

/usr/sbin/rsyslogd

exec java -server ${JAVA_OPTS} ${JAVA_OPTS_DEFAULT} -cp ${CLASSPATH_DEFAULT} com.hazelcast.core.server.StartServer 2>&1 | logger --server localhost --udp -s -t hazelcast-static