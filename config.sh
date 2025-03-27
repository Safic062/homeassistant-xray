#!/bin/sh

echo "Make /etc/xray/config.json"

rm /etc/xray/config.json

# Генерация конфигурации
cat <<EOF > /etc/xray/config.json
{
  "bridges": [
EOF

# Перебор всех элементов массива bridges
index=0
while bashio::config "bridges.${index}.domain" > /dev/null; do
  DOMAIN=$(bashio::config "bridges.${index}.domain")
  LOCAL=$(bashio::config "bridges.${index}.local")
  PORTAL_ADDRESS=$(bashio::config "bridges.${index}.portal_address")
  PORTAL_PORT=$(bashio::config "bridges.${index}.portal_port")
  PORTAL_USER_ID=$(bashio::config "bridges.${index}.portal_user_id")
  IN_TAG=$(bashio::config "bridges.${index}.in_tag")
  OUT_TAG=$(bashio::config "bridges.${index}.out_tag")

  # Добавление элемента в массив bridges
  cat <<EOF >> /etc/xray/config.json
    {
      "tag": "$IN_TAG",
      "domain": "$DOMAIN"
    }${next_comma}
EOF

  index=$((index + 1))
  next_comma=","
done

# Продолжение конфигурации
cat <<EOF >> /etc/xray/config.json
  ],
  "outbound": [
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
  ],
  "routing": {
    "rules": [
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
    ]
  }
}
EOF

echo "Конфигурация успешно сгенерирована: /etc/xray/config.json"

cat /etc/xray/config.json

echo "-------"