# Docker container for running Apache

FROM       d11wtq/ubuntu:14.04
MAINTAINER Chris Corbyn <chris@w3style.co.uk>

RUN sudo apt-get update -qq -y
RUN sudo apt-get install -qq -y \
    libapr1-dev                 \
    libaprutil1-dev

ENV HTTPD_MIRROR http://apache.mirror.serversaustralia.com.au
ENV HTTPD_VERSION 2.4.16

RUN cd /tmp;                                                   \
    curl -LO $HTTPD_MIRROR/httpd/httpd-$HTTPD_VERSION.tar.bz2; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                       \
    cd httpd-*;                                                \
    ./configure                                                \
      --prefix=/usr/local                                      \
      --with-config-file-path=/www                             \
      --enable-so                                              \
      --enable-cgi                                             \
      --enable-info                                            \
      --enable-rewrite                                         \
      --enable-deflate                                         \
      --enable-ssl                                             \
      --with-mpm=prefork                                       \
      --enable-mime-magic                                      \
      ;                                                        \
    make && make install;                                      \
    cd; rm -rf /tmp/httpd-*

ADD www /www

EXPOSE 8080
CMD    [ "apachectl", \
         "-d", "/usr/local", \
         "-f", "/www/httpd.conf", \
         "-DFOREGROUND" ]
