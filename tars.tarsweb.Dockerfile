FROM ubuntu:20.04 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/;s/security.ubuntu.com/mirrors.aliyun.com/;' /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
  nodejs npm python build-essential  telnet curl wget iputils-ping vim tcpdump net-tools 

RUN mkdir /tars-web
COPY tarsweb.tar /tars-web
RUN cd /tars-web && ls -lh /tars-web  && tar xfv tarsweb.tar
RUN npm config set registry http://mirrors.cloud.tencent.com/npm/
RUN cd /tars-web/client && npm install
RUN cd /tars-web/client && npm run build && rm -rf node_modules src static
RUN rm -f /tars-web/tarsweb.tar
RUN cd /tars-web && npm cache verify && npm cache clean --force && npm install

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/;s/security.ubuntu.com/mirrors.aliyun.com/;' /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

COPY files/binary/tars2case /usr/local/tars/cpp/tools/tars2case
COPY --from=build /tars-web /tars-web

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo Asia/Shanghai > /etc/timezone

ENV LANG=C.UTF-8

WORKDIR /tars-web
CMD ["node", "bin/www"]
