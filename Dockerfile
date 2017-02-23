FROM twanislas/base-alpine:latest
MAINTAINER Antoine Rahier <antoine.rahier@gmail.com>
LABEL maintainer="Antoine Rahier <antoine.rahier@gmail.com>"

# Build-time metadata
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.name="docker-jackett" \
      org.label-schema.description="Docker container for Jackett, based on latest Alpine Linux" \
      org.label-schema.url="https://github.com/Twanislas/docker-jackett" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/Twanislas/docker-jackett" \
      org.label-schema.vendor="Antoine Rahier" \
      org.label-schema.version="$VERSION" \
      org.label-schema.schema-version="1.0"

# FreeNAS metadata
LABEL org.freenas.autostart="true" \
      org.freenas.bridged="false" \
      org.freenas.expose-ports-at-host="true" \
      org.freenas.port-mappings="9117:9117/tcp" \
      org.freenas.settings="[ \
        { \
            \"env\": \"JACKETT_UID\", \
            \"descr\": \"User ID to run Jackett\", \
            \"optional\": true \
        }, \
        { \
            \"env\": \"JACKETT_GID\", \
            \"descr\": \"Group ID to run Jackett\", \
            \"optional\": true \
        } \
      ]" \
      org.freenas.upgradeable="true" \
      org.freenas.version="$VERSION" \
      org.freenas.volumes="[ \
        { \
            \"name\": \"/config\", \
            \"descr\": \"Config volume/dataset\" \
        }, \
        { \
            \"name\": \"/data\", \
            \"descr\": \"Data volume/dataset\" \
        } \
      ]" \
      org.freenas.web-ui-protocol="http" \
      org.freenas.web-ui-port=9117 \
      org.freenas.web-ui-path=""

# Add repos and install what we need
RUN \
  echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk upgrade --no-cache && \
  apk add --no-cache mono@testing libcurl

# Install Jackett
RUN wget "https://github.com/Jackett/Jackett/releases/download/$(wget -q https://github.com/Jackett/Jackett/releases/latest -O - | grep -E \/tag\/ | awk -F "[><]" '{print $3}')/Jackett.Binaries.Mono.tar.gz" && \
    tar -xzf Jackett.Binaries.Mono.tar.gz && \
    rm Jackett.Binaries.Mono.tar.gz

# Copy needed files
COPY rootfs/ /

# Ports
EXPOSE 9117/tcp

# Volumes
VOLUME /config /data

# Health check
HEALTHCHECK CMD curl --connect-timeout 15 --show-error --silent --fail --location "http://localhost:9117" > /dev/null || exit 1
