#!/usr/bin/with-contenv bashio

echo "Make /etc/xray/config.json"

rm /etc/xray/config.json

# Генерация конфигурации
cat <<EOF > /etc/xray/config.json
{
  "bridges": [
EOF

# Перебор всех элементов массива bridges

# for login in $(bashio::config 'logins|keys'); do
#   bashio::config.require.username "logins[${login}].username"
#   bashio::config.require.password "logins[${login}].password"

#   username=$(bashio::config "logins[${login}].username")
#   password=$(bashio::config "logins[${login}].password")

#-----

# # Пример массива строк
# arr=("apple" "banana" "cherry" "date")

# # Переменная для хранения итоговой строки
# result=""

# # Обход массива и добавление элементов в строку
# for item in "${arr[@]}"; do
#     if [ -n "$result" ]; then
#         result="$result,$item"
#     else
#         result="$item"
#     fi
# done

# echo "Результат: $result"

for bridge in $(bashio::config 'bridges|keys'); do
  echo "bridge: $bridge"
#while bashio::config "bridges.${index}.domain" > /dev/null; do
#   bashio::config.require.domain "bridges[${bridge}].domain"
#   bashio::config.require.local "bridges[${bridge}].local"
#   bashio::config.require.portal_address "bridges[${bridge}].portal_address"
#   bashio::config.require.portal_port "bridges[${bridge}].portal_port"
#   bashio::config.require.portal_user_id "bridges[${bridge}].portal_user_id"
#   bashio::config.require.in_tag "bridges[${bridge}].in_tag"
#   bashio::config.require.out_tag "bridges[${bridge}].out_tag"

  DOMAIN=$(bashio::config "bridges.${bridge}.domain")
  LOCAL=$(bashio::config "bridges.${bridge}.local")
  PORTAL_ADDRESS=$(bashio::config "bridges.${bridge}.portal_address")
  PORTAL_PORT=$(bashio::config "bridges.${bridge}.portal_port")
  PORTAL_USER_ID=$(bashio::config "bridges.${bridge}.portal_user_id")
  IN_TAG=$(bashio::config "bridges.${bridge}.in_tag")
  OUT_TAG=$(bashio::config "bridges.${bridge}.out_tag")

  # Добавление элемента в массив bridges
  cat <<EOF >> /etc/xray/config.json
    {
      "tag": "$IN_TAG",
      "domain": "$DOMAIN"
    }
EOF

#   index=$((index + 1))
#   next_comma=","
done

# # Продолжение конфигурации
# cat <<EOF >> /etc/xray/config.json
#   ],
#   "outbound": [
#     {
#       "tag": "$OUT_TAG",
#       "protocol": "freedom",
#       "settings": {
#         "redirect": "$LOCAL"
#       }
#     },
#     {
#       "protocol": "vmess",
#       "settings": {
#         "vnext": [
#           {
#             "address": "$PORTAL_ADDRESS",
#             "port": $PORTAL_PORT,
#             "users": [
#               {
#                 "id": "$PORTAL_USER_ID"
#               }
#             ]
#           }
#         ]
#       },
#       "tag": "interconn"
#     }
#   ],
#   "routing": {
#     "rules": [
#       {
#         "type": "field",
#         "inboundTag": ["$IN_TAG"],
#         "domain": ["full:$DOMAIN"],
#         "outboundTag": "interconn"
#       },
#       {
#         "type": "field",
#         "inboundTag": ["$IN_TAG"],
#         "outboundTag": "$OUT_TAG"
#       }
#     ]
#   }
# }
# EOF

echo "Конфигурация успешно сгенерирована: /etc/xray/config.json"

cat /etc/xray/config.json

echo "-------"