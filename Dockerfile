FROM chriswayg/apache-php
MAINTAINER Christian Wagner chriswayg@gmail.com

# Concrete5 installed at root of site
# - changes required permissions incl. for multi-lingual sites
# - find latest download link at https://www.concrete5.org/get-started

ENV CONCRETE5_VERSION 5.7.5.1

RUN apt-get -y update && \
      DEBIAN_FRONTEND=noninteractive apt-get -y install \
      php5-curl \
      php5-gd \
      php5-mysql \
      unzip \
      wget && \
    apt-get clean && rm -r /var/lib/apt/lists/*

WORKDIR /var/www/html

# for newer version: change Concrete5 download url & md5
RUN c5url="https://www.concrete5.org/download_file/-/view/81601/" && \
    c5md5="a412a72358197212532c92803d7a1021" && \
    wget --no-verbose ${c5url} -O concrete5.zip && \
    echo "${c5md5}  concrete5.zip" > concrete5.md5 && \
    md5sum -c concrete5.md5 && \
    c5dir=$(unzip -qql concrete5.zip | head -n1 | tr -s ' ' | cut -d' ' -f5-) && \
    unzip -qq concrete5.zip && \
    mv ${c5dir}* . && \
    rmdir -v ${c5dir} && rm -v concrete5.md5 concrete5.zip index.html && \
    chown -Rv root:www-data application/files/ && \
    chmod -Rv 775 application/files/ && \
    chown -Rv root:www-data application/config/ && \
    chmod -Rv 775 application/config/ && \
    chown -Rv root:www-data packages/ && \
    chmod -Rv 775 packages/ && \
    chown -Rv root:www-data updates/ && \
    chmod -Rv 775 updates/ && \
    mkdir -v  application/languages/site && \
    chown -Rv root:www-data application/languages/site && \
    chmod -Rv 775 application/languages/site

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/apache2-foreground"]
