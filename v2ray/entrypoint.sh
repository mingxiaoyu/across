#!/bin/sh

echo "modify v2ray config ..."
sed -i "s@V2_UUID@${V2_UUID}@g" /etc/v2ray/config.json
sed -i "s@V2_WS_PATH_VLESS@${V2_WS_PATH_VLESS}@g" /etc/v2ray/config.json
echo "modify v2ray config completed"

if  [[ $CADDY = "true" ]];
then
echo "run caddy ..."
/usr/bin/caddy start
#curl localhost:2019/load \
#  -X POST \
#  -H "Content-Type: application/json" \
#  -d @caddy.json
echo "run caddy completed"
fi

echo "run v2ray"
/usr/bin/xray -config /etc/v2ray/config.json
