#FROM eclipse-temurin:17-jre
FROM eclipse-temurin:17 as jre-build

# Create a custom Java runtime / to get the required modules use `jdeps -s jars/<binary>.jar`
RUN $JAVA_HOME/bin/jlink \
          # tigase-server
         --add-modules java.base \
         --add-modules java.logging \
         --add-modules java.management \
         --add-modules java.management.rmi \
         --add-modules java.rmi \
         --add-modules java.naming \
         --add-modules jdk.naming.rmi \
         --add-modules jdk.naming.dns \
         --add-modules java.security.sasl \
         --add-modules java.sql \
         --add-modules jdk.management \
          # java.scripting can probably removed after removing groovy
         --add-modules java.scripting \
          # required for WebSockets
         --add-modules java.net.http \
          # required for TLS
         --add-modules jdk.crypto.ec \
          # tigase-http-api
         --add-modules java.desktop \
         --add-modules jdk.httpserver \
          # groovy
         --add-modules java.compiler \
         --add-modules java.prefs \
         --add-modules java.xml \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output ./javaruntime

# Define your base image
FROM debian:bullseye-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME

MAINTAINER "Tigase, Inc." <support@tigase.net>

# Create directory structure, download Tigase XMPP Server -dist-max package and unpack it
# At the same time remove setting JAVA_HOME from etc/tigase.conf as variable is already set
# Then move content of etc/ directory to etc.orig/ to be able to use volume to host configuration.
# Additionally we are removing docs/ and downloaded package to reduce size.

ARG TYPE=""
ENV TYPE ${TYPE}

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates curl less \
	&& rm -rf /var/lib/apt/lists/*
