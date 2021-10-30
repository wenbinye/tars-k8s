FROM ubuntu:20.04 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/;s/security.ubuntu.com/mirrors.aliyun.com/;' /etc/apt/sources.list
RUN apt update
RUN apt install -y php-dev binutils

ENV SWOOLE_VERSION=4.6.7
RUN yes yes | pecl install swoole-$SWOOLE_VERSION
RUN strip /usr/lib/php/20190902/swoole.so

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    ServerType=php

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/;s/security.ubuntu.com/mirrors.aliyun.com/;' /etc/apt/sources.list \
  && apt update && apt install -y \
  php-cli \
  php-curl \
  php-fileinfo \
  php-gd \
  php-mbstring \
  php-mysql \
  php-redis \
  php-soap \
  php-sybase \
  php-zip \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/lib/php/20190902/swoole.so /usr/lib/php/20190902/
COPY files/entrypoint.sh /bin/entrypoint.sh

RUN  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo Asia/Shanghai > /etc/timezone \
  && echo "extension=swoole.so" > /etc/php/7.4/cli/conf.d/20-swoole.ini \
  && mkdir -p /usr/local/server/bin/ \
  && chmod +x /bin/entrypoint.sh

CMD ["/bin/entrypoint.sh"]

