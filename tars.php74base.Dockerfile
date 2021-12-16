FROM ubuntu:20.04 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/;s/security.ubuntu.com/mirrors.aliyun.com/;' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y php-dev binutils
RUN apt-get install -y libcurl4-openssl-dev

ENV SWOOLE_VERSION=4.6.7
RUN yes yes | pecl install swoole-$SWOOLE_VERSION
RUN strip /usr/lib/php/20190902/swoole.so

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    ServerType=php \
    LANG=C.UTF-8

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/;s/security.ubuntu.com/mirrors.aliyun.com/;' /etc/apt/sources.list \
  && apt-get update && apt-get install -y \
  curl \
  php-bcmath \
  php-cli \
  php-curl \
  php-fileinfo \
  php-gd \
  php-ldap \
  php-mbstring \
  php-mysql \
  php-pgsql \
  php-redis \
  php-soap \
  php-sybase \
  php-xml \
  php-zip \
  vim-tiny \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/lib/php/20190902/swoole.so /usr/lib/php/20190902/
COPY files/entrypoint.sh /bin/entrypoint.sh
COPY files/.bash_aliases /root/

RUN  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo Asia/Shanghai > /etc/timezone \
  && echo "extension=swoole.so" > /etc/php/7.4/cli/conf.d/20-swoole.ini \
  && mkdir -p /usr/local/server/bin/ \
  && chmod +x /bin/entrypoint.sh

WORKDIR /usr/local/server/bin

CMD ["/bin/entrypoint.sh"]
