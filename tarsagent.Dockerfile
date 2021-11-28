FROM docker:19.03 As First

FROM ubuntu:20.04

ENV LANG=C.UTF-8


COPY --from=First /usr/local/bin/docker /usr/local/bin/docker
COPY files/binary/tarsagent /usr/local/app/tars/tarsagent/bin/tarsagent

RUN chmod +x /usr/local/app/tars/tarsagent/bin/tarsagent \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo Asia/Shanghai > /etc/timezone 

CMD ["/usr/local/app/tars/tarsagent/bin/tarsagent"]
