# Dockerfile for v2ray based alpine

FROM alpine:latest
COPY config.json /etc/v2ray/config.json

RUN apk add --no-cache --virtual .build-deps ca-certificates
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV TZ=Asia/Shanghai

ENTRYPOINT ["/entrypoint.sh"]

