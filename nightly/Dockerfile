FROM openjdk:11-jre-slim
MAINTAINER "Tigase, Inc." <office@tigase.net>

# Create directory structure, download Tigase XMPP Server -dist-max package and unpack it
# At the same time remove setting JAVA_HOME from etc/tigase.conf as variable is already set
# Then move content of etc/ directory to etc.orig/ to be able to use volume to host configuration.
# Additionally we are removing docs/ and downloaded package to reduce size.
RUN mkdir /home/tigase \
	&& cd /home/tigase \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends wget \
	&& wget https://build.tigase.net/nightlies/dists/latest/tigase-server-dist-max.tar.gz \
	&& apt-get remove -y wget \
	&& rm -rf /var/lib/apt/lists/* \
	&& tar -zxvf tigase-server-dist-max.tar.gz \
	&& ln -s `find . -name 'tigase-server-*' -maxdepth 1 -type d` tigase-server \
	&& rm -rf tigase-server/docs/ \
	&& rm -rf tigase-server-dist-max.tar.gz \
	&& sed -i -e 's/JAVA_HOME/#JAVA_HOME/' tigase-server/etc/tigase.conf \
	&& mv tigase-server/etc tigase-server/etc.orig

# Add statup scripts and make them executable
# We need custom scripts to make sure that database is upgraded
# and that Tigase will NOT be launched as background service!
ADD scripts/start.sh /start.sh
ADD scripts/tigase.sh /tigase.sh
RUN chmod 755 /start.sh
RUN chmod 755 /tigase.sh

# Set TIGASE_HOME variable
ENV TIGASE_HOME /home/tigase/tigase-server

# Set ports of the container which can be exposed
EXPOSE 5222 5223 5277 5280 5281 5290 5291 8080 9050 9070

# Set possible volume (directories which can be mounted from the docker host machine)
# like etc/, conf/, certs/, logs/, data/
VOLUME ["/home/tigase/tigase-server/etc", "/home/tigase/tigase-server/conf", "/home/tigase/tigase-server/certs", "/home/tigase/tigase-server/logs", "/home/tigase/tigase-server/data"]

# Define script which should be executed on container startup
CMD ["/bin/bash", "/start.sh"]
