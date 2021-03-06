#!/bin/sh

echo "modify v2ray config ..."
sed -i "s@V2_UUID@${V2_UUID}@g" /v2/config.json
sed -i "s@V2_WS_PATH_VLESS@${V2_WS_PATH_VLESS}@g" /v2/config.json
sed -i "s@TROJAN_WS_PATH@${TROJAN_WS_PATH}@g" /v2/config.json
sed -i "s@TROJAN_PWD@${TROJAN_PWD}@g" /v2/config.json
echo "modify v2ray config completed"

if  [[ $CADDY = "true" ]];
then
echo "run caddy ..."
chmod +x ./caddy
./caddy start
#curl localhost:2019/load \
#  -X POST \
#  -H "Content-Type: application/json" \
#  -d @caddy.json
echo "run caddy completed"
fi

echo "run v2ray"
chmod +x ./xray
./xray -config config.json
