FROM chriswayg/apache-php
MAINTAINER Christian Wagner chriswayg@gmail.com

# This image provides Concrete5.7 at root of site
# - latest download link at https://www.concrete5.org/get-started
# - for newer version: change Concrete5 download url & md5
ENV CONCRETE5_VERSION 5.7.5.1
ENV C5_URL https://www.concrete5.org/download_file/-/view/81601/
ENV C5_MD5 a412a72358197212532c92803d7a1021

# Install pre-requisites for Concrete5
RUN apt-get -y update && \
      DEBIAN_FRONTEND=noninteractive apt-get -y install \
      php5-curl \
      php5-gd \
      php5-mysql \
      unzip \
      wget && \
    apt-get clean && rm -r /var/lib/apt/lists/*

WORKDIR /usr/local/src

# Download Concrete5
# - changes required permissions incl. for multi-lingual sites
RUN wget --no-verbose $C5_URL -O concrete5.zip && \
    echo "$C5_MD5  concrete5.zip" > concrete5.md5 && \
    md5sum -c concrete5.md5 && \
    c5_dir=$(unzip -qql concrete5.zip | head -n1 | tr -s ' ' | cut -d' ' -f5-) && \
    unzip -qq concrete5.zip

# Website user data & apache config
VOLUME [ "/var/www/html", "/etc/apache2" ]

EXPOSE 80 443

ENTRYPOINT ["/docker-entrypoint"]
