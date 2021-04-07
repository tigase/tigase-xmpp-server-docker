#!/bin/bash
cp -r -n /home/tigase/tigase-server/etc.orig/* /home/tigase/tigase-server/etc/

if [ -n "${DB_HOST}" ] && [ -n "${DB_PORT}" ] ; then
  ./scripts/wait-for-it.sh "${DB_HOST}":"${DB_PORT}" -t 30
fi
if grep -q "config-type.*setup" "/home/tigase/tigase-server/etc/config.tdsl" ; then
  echo "Running in setup mode, skipping schema upgrade...";
else
  echo "Upgrading database schema... x";
  /home/tigase/tigase-server/scripts/tigase.sh upgrade-schema /home/tigase/tigase-server/etc/tigase.conf -R "${DB_ROOT_USER}" -A "${DB_ROOT_PASS}" -L "${DB_LOG_LEVEL}"
fi

echo "Starting Tigase XMPP Server...";
/home/tigase/tigase-server/scripts/tigase.sh run /home/tigase/tigase-server/etc/tigase.conf
