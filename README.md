Tigase's Docker package for the Tigase XMPP Server.

**Please note! This is still experimental and under development. Not ready for production as it is now but a good starting point for further customizations and adjusting to specific needs.**

<!-- START doctoc -->
<!-- END doctoc -->

# Supported tags and respective `Dockerfile`s

## Simple tags
-   [`latest-jdk11-slim` (*latest/jdk-11/slim/Dockerfile*)](latest/jdk-11/slim/Dockerfile)
-   [`8.1.0-jdk11-slim` (*8.1.0/jdk-11/slim/Dockerfile*)](8.1.0/jdk-11/slim/Dockerfile)
-   [`8.0.0-jdk11-slim` (*8.0.0/jdk-11/slim/Dockerfile*)](8.0.0jdk-11/slim/Dockerfile)
-   [`8.0.0-jdk8-slim` (*8.0.0/jdk-8/slim/Dockerfile*)](8.0.0/jdk-8/slim/Dockerfile)

# What is Tigase XMPP server?

[Tigase XMPP Server](https://tigase.tech/projects/tigase-server) is scalable and performant implementation of the XMPP server written in Java.

For more informations about Tigase XMPP Server and related products, please visit https://tigase.net and https://tigase.tech.

Documentation for Tigase XMPP Server is available at https://docs.tigase.net.

# How to use this image?

## Starting Tigase XMPP Server

Starting Tigase XMPP Server is very simple:

````bash
$ docker run --name some-tigase -d tigase:tag
````

where `some-tigase` is name of the container to use and `tag` is the tag specifying version of Tigase XMPP Server to run.

If Tigase XMPP Server is started for the first time (without any configuration), it will start web-based setup at port 8080.

## Setting hostname

In some cases, ie. in clustering, you may want to change hostname of the container of Tigase XMPP Server. To do so you need to add `--hostname domain.com` to the list of `docker run` parameters.

## Exposing ports

Tigase XMPP Server as the XMPP server is only useful if accessible from the outside of the container. Tigase exposes following ports:
- `5222` - for incoming client to server XMPP connections
- `5223` - for incoming client to server XMPP connections over TLS/SSL
- `5277` - for inter-cluster communication
- `5280` - for BOSH connections
- `5281` - for BOSH connections over TLS/SSL
- `5290` - for WebSocket connections
- `5291` - for WebSocket connections over TLS/SSL
- `8080` - for HTTP server (web-based setup, REST API, file upload extension, etc.)

Docker image defines all of the above ports as exportable, however it depends on the Tigase XMPP Server configuration if particular service is available at any of those ports.

## Connecting to external database

If you want to use Tigase XMPP Server with the external database you need to connect Tigase XMPP Server container to the database container or allow Tigase XMPP Server to access database server.

Tigase XMPP Server supports following databases:
- DerbyDB
- MySQL
- MSSQL
- PostgreSQL
- MongoDB

for details about required version of the databases please check Tigase XMPP Server documentation at https://docs.tigase.net/.

It is recommended to pass database username and password for creation and schema management of the database.

````bash
$ docker run -e 'DB_ROOT_USER=root' -e 'DB_ROOT_PASS=root-pass' --name some-tigase -d tigase:tag
````

This will allow Tigase XMPP Server to manage and verify database schema.

Database configuration may be then done using web-based setup.

## Exported volumes

This image exports following volumes to allow you to keep configuration, logs and persistent data outside of the container:
- `/home/tigase/tigase-server/etc/` - configuration of the server *(default config files will be created after first startup of the container)*
- `/home/tigase/tigase-server/certs/` - SSL certificates for use by the server for securing connectivity
- `/home/tigase/tigase-server/logs/` - detailed logs of the server
- `/home/tigase/tigase-server/data/` - data stored by HTTP-based file upload feature of the server
