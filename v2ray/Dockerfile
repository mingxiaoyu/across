FROM alpine:latest

#定义时区参数
ENV TZ=Asia/Shanghai
ENV V2_UUID=V2RAYUUID
ENV V2_WS_PATH_VLESS=V2RAYWSPATH
ENV CADDY=true
ENV DOWNLOAD_URL=https://github.com/caddyserver/caddy/releases/download/v2.3.0/caddy_2.3.0_linux_amd64.tar.gz

RUN apk add --no-cache --virtual .buiders \
	wget bash curl

	
#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

WORKDIR /v2

RUN curl -fsSL "$DOWNLOAD_URL" -o "caddy_linux_amd64.tar.gz" \
		&& tar -zxvf  caddy_linux_amd64.tar.gz caddy \
		&& rm caddy_linux_amd64.tar.gz \
        && chmod +x /v2/caddy

RUN wget -O /v2/xray https://dl.lamp.sh/files/xray_linux_386 \
	&& chmod +x /v2/xray

COPY config.json config.json
COPY caddy.json	caddy.json
COPY Caddyfile Caddyfile

ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
