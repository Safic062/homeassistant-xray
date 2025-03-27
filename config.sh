#!/usr/bin/with-contenv bashio

echo "Make /etc/xray/config.json"

rm /etc/xray/config.json

# Генерация конфигурации
CF_BRIDGES=""
CF_OUTBOUNDS=""
CF_ROUTING=""
SEPARATOR=""

for index in $(bashio::config 'bridges|keys'); do
#while bashio::config "bridges.${index}.domain" > /dev/null; do
#   bashio::config.require.domain "bridges[${bridge}].domain"
#   bashio::config.require.local "bridges[${bridge}].local"
#   bashio::config.require.portal_address "bridges[${bridge}].portal_address"
#   bashio::config.require.portal_port "bridges[${bridge}].portal_port"
#   bashio::config.require.portal_user_id "bridges[${bridge}].portal_user_id"
#   bashio::config.require.in_tag "bridges[${bridge}].in_tag"
#   bashio::config.require.out_tag "bridges[${bridge}].out_tag"

  DOMAIN=$(bashio::config "bridges[${index}].domain")
  LOCAL=$(bashio::config "bridges[${index}].local")
  PORTAL_ADDRESS=$(bashio::config "bridges[${index}].portal_address")
  PORTAL_PORT=$(bashio::config "bridges[${index}].portal_port")
  PORTAL_USER_ID=$(bashio::config "bridges[${index}].portal_user_id")
  IN_TAG=$(bashio::config "bridges[${index}].in_tag")
  OUT_TAG=$(bashio::config "bridges[${index}].out_tag")

  # Добавление элемента в массив bridges
  CF_BRIDGES=$CF_BRIDGES$(cat <<EOF
$SEPARATOR
      {
        "tag": "$IN_TAG",
        "domain": "$DOMAIN"
      }
EOF
)

  CF_OUTBOUNDS=$CF_OUTBOUNDS$(cat <<EOF
$SEPARATOR
    {
      "tag": "$OUT_TAG",
      "protocol": "freedom",
      "settings": {
        "redirect": "$LOCAL"
      }
    },
    {
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "$PORTAL_ADDRESS",
            "port": $PORTAL_PORT,
            "users": [
              {
                "id": "$PORTAL_USER_ID"
              }
            ]
          }
        ]
      },
      "tag": "interconn"
    }
EOF
)

  CF_ROUTING=$CF_ROUTING$(cat <<EOF
$SEPARATOR
      {
        "type": "field",
        "inboundTag": ["$IN_TAG"],
        "domain": ["full:$DOMAIN"],
        "outboundTag": "interconn"
      },
      {
        "type": "field",
        "inboundTag": ["$IN_TAG"],
        "outboundTag": "$OUT_TAG"
      }
EOF
)

  SEPARATOR=","
done

# Продолжение конфигурации
cat <<EOF >> /etc/xray/config.json
{
  "reverse": {
    "bridges": [
$CF_BRIDGES
    ]
  },
  "outbounds": [
$CF_OUTBOUNDS
  ],
  "routing": {
    "rules": [
$CF_ROUTING
    ]
  }
}
EOF

echo "Конфигурация успешно сгенерирована: /etc/xray/config.json"

cat /etc/xray/config.json

echo "-------"