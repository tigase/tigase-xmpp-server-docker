#FROM eclipse-temurin:17-jre
FROM eclipse-temurin:17 as jre-build

# Create a custom Java runtime / to get the required modules use `jdeps -s jars/<binary>.jar`
RUN $JAVA_HOME/bin/jlink \
          # tigase-server
         --add-modules java.base \
         --add-modules java.logging \
         --add-modules java.management \
         --add-modules java.naming \
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
RUN mkdir /home/tigase \
	&& cd /home/tigase \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates wget curl less \
	&& wget -nv https://build.tigase.net/nightlies/dists/latest/tigase-server-dist-enterprise.tar.gz \
	&& apt-get remove -y wget \
	&& rm -rf /var/lib/apt/lists/* \
	&& tar -zxf tigase-server-dist-enterprise.tar.gz \
	&& ln -s `find . -name 'tigase-server-*' -maxdepth 1 -type d` tigase-server \
	&& rm -rf tigase-server/docs/ \
	&& rm -rf tigase-server-dist-enterprise.tar.gz \
	&& sed -i -e 's/JAVA_HOME/#JAVA_HOME/' tigase-server/etc/tigase.conf \
	&& mv tigase-server/etc tigase-server/etc.orig

# Add statup scripts and make them executable
# We need custom scripts to make sure that database is upgraded
# and that Tigase will NOT be launched as background service!
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Set TIGASE_HOME variable
ENV TIGASE_HOME /home/tigase/tigase-server

# Set ports of the container which can be exposed
EXPOSE 5222 5223 5269 5277 5280 5281 5290 5291 8080 9050 9070

# Set possible volume (directories which can be mounted from the docker host machine)
# like etc/, conf/, certs/, logs/, data/
VOLUME ["/home/tigase/tigase-server/etc", "/home/tigase/tigase-server/conf", "/home/tigase/tigase-server/certs", "/home/tigase/tigase-server/logs", "/home/tigase/tigase-server/data"]

# Define script which should be executed on container startup
CMD ["/bin/bash", "/start.sh"]
