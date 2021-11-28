FROM ubuntu:20.04

ENV LANG=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo Asia/Shanghai > /etc/timezone 

RUN apt-get update \
 && apt-get install -y \
    ca-certificates openssl  \
 && apt purge -y                                                                       \
    && apt clean all                                                                   \
    && rm -rf /var/lib/apt/lists/*                                                     \
    && rm -rf /var/cache/*.dat-old                                                     \
    && rm -rf /var/log/*.log /var/log/*/*.log

COPY files/template/tarscontroller/root /
COPY files/binary/tarscontroller /usr/local/app/tars/tarscontroller/bin/tarscontroller

CMD ["bash", "/bin/entrypoint.sh"]
