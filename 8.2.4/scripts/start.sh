#!/bin/bash

if [[ ! -z "$COPY_CONFIG_SRC" ]]; then
echo "Copying config from $COPY_CONFIG_SRC ..."
cp -L -r -n -v "$COPY_CONFIG_SRC/config.tdsl" /home/tigase/tigase-server/etc
echo "--------------------------------------"
fi

cp -r -n /home/tigase/tigase-server/etc.orig/* /home/tigase/tigase-server/etc/

echo "Checking if database is already available: ${DB_HOST}:${DB_PORT}";
if [ -n "${DB_HOST}" ] && [ -n "${DB_PORT}" ] ; then
  /home/tigase/tigase-server/scripts/wait-for-it.sh "${DB_HOST}":"${DB_PORT}" -t 30
fi
if grep -q "config-type.*setup" "/home/tigase/tigase-server/etc/config.tdsl" ; then
  echo "Running in setup mode, skipping schema upgrade...";
else
  echo "Upgrading database schema...";
  ADDITIONAL_PARAMS=""
  if [[ ! -z "$ADMIN_JID" && ! -z "$ADMIN_PASSWORD" ]]; then
	  ADDITIONAL_PARAMS="$ADDITIONAL_PARAMS --adminJID=\"$ADMIN_JID\" --adminJIDpass=\"$ADMIN_PASSWORD\"";
  fi
  if [[ ! -z "$DB_ROOT_USER" && ! -z "$DB_ROOT_PASS" ]]; then
	  ADDITIONAL_PARAMS="$ADDITIONAL_PARAMS -R \"${DB_ROOT_USER}\" -A \"${DB_ROOT_PASS}\"";
  fi
  if [[ ! -z "$DB_LOG_LEVEL" ]]; then
	  ADDITIONAL_PARAMS="$ADDITIONAL_PARAMS -L \"${DB_LOG_LEVEL}\"";
  fi
  /home/tigase/tigase-server/scripts/tigase.sh upgrade-schema /home/tigase/tigase-server/etc/tigase.conf "$ADDITIONAL_PARAMS"
fi

echo "Starting Tigase XMPP Server...";
/home/tigase/tigase-server/scripts/tigase.sh run /home/tigase/tigase-server/etc/tigase.conf
