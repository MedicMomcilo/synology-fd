#!/bin/bash
#
# prepare running docker container for services
# runs each time container starts

PARAMS="$@"

#create initial config
cat << EOF > /etc/bareos/bareos-fd.d/bareos-fd/filedaemon.conf
FileDaemon {
  Name = ${NAME}-fd
  Heartbeat Interval = 60
}

Director {
  Name = ${DIRECTOR}-dir
  Password = ${FDPASS}
}

Messages {
  Name = Standard
  director = ${DIRECTOR}-dir = all, !skipped, !restored
}
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') Start Daemons" >>/var/log/bareos/bareos.log
#fix permissions
chown -R bareos:bareos /etc/bareos /var/log/bareos

#run services
service bareos-fd stop && service bareos-fd start

exec $PARAMS
