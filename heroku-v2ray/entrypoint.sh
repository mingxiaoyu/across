#!/bin/sh

wget -O /usr/bin/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
wget -O /usr/bin/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

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

echo "Download binary file: ${XRAY_FILE} completed"
chmod +x /usr/bin/xray
 
echo "xray port: ${PORT} completed"
sed -i "s@V2RAYPORT@${PORT}@g" /etc/v2ray/config.json

echo "run v2ray"
/usr/bin/xray -config /etc/v2ray/config.json
