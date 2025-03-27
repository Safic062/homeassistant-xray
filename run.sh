#!/usr/bin/with-contenv bashio

echo "Hello X-Ray!"

/root/config.sh

/usr/bin/xray --config /etc/xray/config.json
