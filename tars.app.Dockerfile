FROM ubuntu:20.04

COPY files/entrypoint.sh /bin/entrypoint.sh

RUN  chmod +x /bin/entrypoint.sh \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo Asia/Shanghai > /etc/timezone \
  && mkdir -p /usr/local/server/bin/

COPY files/binary/{{app}} /usr/local/server/bin/
ENV ServerType=cpp \
    LANG=C.UTF-8
    
CMD ["/bin/entrypoint.sh"]
