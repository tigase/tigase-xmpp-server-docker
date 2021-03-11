#!/bin/bash
cp -r -n /home/tigase/tigase-server/etc.orig/* /home/tigase/tigase-server/etc/

if grep -q "config-type.*setup" "/home/tigase/tigase-server/etc/config.tdsl" ; then
  echo "Running in setup mode, skipping schema upgrade...";
else
  echo "Upgrading database schema...";
  ./tigase.sh upgrade-schema /home/tigase/tigase-server/etc/tigase.conf -R ${DB_ROOT_USER} -A ${DB_ROOT_PASS}
fi

echo "Starting Tigase XMPP Server...";
./tigase.sh run /home/tigase/tigase-server/etc/tigase.conf
