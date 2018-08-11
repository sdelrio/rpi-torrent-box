ARG BASE_IMAGE=resin/rpi-raspbian:stretch

FROM $BASE_IMAGE

USER root

# For ffmpeg, which is required by the ruTorrent screenshots plugin
# This increases ~53 MB of the image size, remove it if you really don't need screenshots

RUN echo "deb http://www.deb-multimedia.org stretch main" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -q -y --force-yes --no-install-recommends \
    deb-multimedia-keyring \
    ffmpeg

# Install web server, packages and create ssl certificate

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    openssl \
    ca-certificates \
    apache2-utils \
    libc-ares2 \
    nginx \
    php5-cli \
    php5-fpm \
    geoip-database \
    php5-geoip && \
    update-rc.d nginx remove && \
    openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout /etc/ssl/private/rutorrent.key -out /etc/ssl/private/rutorrent.crt -subj /CN=rutorrent && \
    chmod 600 /etc/ssl/private/rutorrent.key

# Install tools, and packages for rutorrent plugins

RUN apt-get update && \
    apt-get install -y --force-yes unzip unrar-free mediainfo curl wget supervisor sox

# Make rtorrent from sources

ENV VERSION 1.20
ENV VER_LIBTORRENT 0.13.6
ENV VER_RTORRENT 0.9.6
ENV build_deps="automake build-essential ca-certificates libc-ares-dev libcppunit-dev libtool libssl-dev libxml2-dev libncurses5-dev pkg-config subversion wget"

WORKDIR /usr/local/src

# Compile rtorrent based on VER_RTORRENT and VER_LIBTORRENT

COPY rtorrent/compiletorrent.sh /usr/local/src/compiletorrent.sh 
RUN /usr/local/src/compiletorrent.sh

# Download base for ruTorrent 

COPY rutorrent/getrutorrent.sh /usr/local/src/getrutorrent.sh
RUN /usr/local/src/getrutorrent.sh

# rtorrent startup

COPY rtorrent/runrtorrent.sh /usr/local/src/runrtorrent.sh

# rtorrent and ruTorrent base configurations

COPY rtorrent/config/.rtorrent.rc /usr/local/src/.rtorrent.rc
COPY rutorrent/config/config.php /usr/local/src/config.php

# Base ruTorrent startup with NGInx in no-daemon mode

COPY rutorrent/runrutorrent.sh /usr/local/src/runrutorrent.sh


# Base configuration for NGinx

COPY nginx/config/rutorrent.conf     /etc/nginx/sites-enabled/default
COPY nginx/config/rutorrent-ssl.conf /etc/nginx/sites-enabled/tls
COPY nginx/config/nginx.conf         /etc/nginx/nginx.conf

# Configure rtorrent user

RUN useradd -d /home/rtorrent -m -s /bin/bash rtorrent
RUN chown -R rtorrent:rtorrent /home/rtorrent

# Geo Codes

RUN curl -LOks http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip GeoLiteCity.dat.gz && \
    mkdir -p /usr/share/GeoIP && mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

# Cleanup repositories

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get purge -y --auto-remove ${build_deps} && apt-get autoremove -y

# Configure supervisor

ADD supervisord/supervisord.conf /etc/supervisor/supervisord.conf

# Ports

EXPOSE 80
EXPOSE 443
EXPOSE 49160
EXPOSE 49161

# Volume for data and rtorrent configuration

VOLUME /rtorrent

#  Change the default login/password of ruTorrent

ENV WEB_USER=user
ENV WEB_PASS=password

RUN PASSWORD="$WEB_PASS";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "$WEB_USER:{SSHA}$SHA1\n" >>  /usr/share/nginx/html/rutorrent/.htpasswd 

CMD ["supervisord"]
