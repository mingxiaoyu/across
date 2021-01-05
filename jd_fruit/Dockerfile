FROM golang:1.15-alpine as builder

RUN apk add --no-cache --virtual .buiders \
	git

WORKDIR /src
RUN git clone -b v0.1.12 https://github.com/aptible/supercronic 
WORKDIR /go/src/github.com/aptible/supercronic

RUN cp -r /src/supercronic/* ./

RUN	go mod vendor \
	&& go install

FROM alpine:latest
COPY --from=builder go/bin/supercronic /usr/local/bin/supercronic
RUN chmod  755 /usr/local/bin/supercronic

RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache --virtual .jd-rundeps \
	curl \
	bash \
    tzdata \
	nodejs \
	npm \
	&& rm -rf /var/cache/apk/* /tmp/* \

#定义时区参数
ENV TZ=Asia/Shanghai
ENV cookie=''
ENV sckey=
ENV cron='5 6-18/6 * * *'

#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

WORKDIR /JD

COPY . .

RUN chown nobody:nobody -R /JD \
	&& chmod  -R 755 /JD

#RUN npm config set registry https://registry.npm.taobao.org 

RUN wget --no-check-certificate -t 3 -T 10 -q https://raw.githubusercontent.com/lxk0301/jd_scripts/master/package.json  -O /JD/package.json \
	&& npm install

USER nobody

ENTRYPOINT ["/JD/entrypoint.sh"]

CMD ["init"]

