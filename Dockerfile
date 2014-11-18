# Docker container for running Apache

FROM       d11wtq/ubuntu:14.04
MAINTAINER Chris Corbyn <chris@w3style.co.uk>

RUN sudo apt-get update -qq -y
RUN sudo apt-get install -qq -y \
    libapr1-dev                 \
    libaprutil1-dev

RUN cd /tmp;                                                              \
    curl -LO http://apache.mirror.uber.com.au/httpd/httpd-2.4.10.tar.bz2; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                                  \
    cd httpd-*;                                                           \
    ./configure                                                           \
      --prefix=/usr/local                                                 \
      --with-config-file-path=/www                                        \
      --enable-so                                                         \
      --enable-cgi                                                        \
      --enable-info                                                       \
      --enable-rewrite                                                    \
      --enable-deflate                                                    \
      --enable-ssl                                                        \
      --enable-mime-magic                                                 \
      ;                                                                   \
    make && make install;                                                 \
    cd; rm -rf /tmp/httpd-*

ADD www /www

EXPOSE 8080
CMD    [ "apachectl", \
         "-d", "/usr/local", \
         "-f", "/www/httpd.conf", \
         "-DFOREGROUND" ]
