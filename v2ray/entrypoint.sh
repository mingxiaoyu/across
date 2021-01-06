#!/bin/sh

ARCH="386"

[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
# Download binary file
XRAY_FILE="xray_linux_${ARCH}"

echo "Downloading binary file: ${V2RAY_FILE}"
wget -O /usr/bin/xray https://dl.lamp.sh/files/${XRAY_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${XRAY_FILE}" && exit 1
fi
echo "Download binary file: ${XRAY_FILE} completed"

echo "modify v2ray config ..."
sed -i "s@V2_UUID@${V2_UUID}@g" /etc/v2ray/config.json
sed -i "s@V2_WS_PATH_VLESS@${V2_WS_PATH_VLESS}@g" /etc/v2ray/config.json
echo "modify v2ray config completed"

#echo "run caddy ..."
#/usr/bin/caddy start
#curl localhost:2019/load \
#  -X POST \
#  -H "Content-Type: application/json" \
#  -d @caddy.json
#echo "run caddy completed"

echo "run v2ray"
chmod +x /usr/bin/xray
/usr/bin/xray -config /etc/v2ray/config.json
