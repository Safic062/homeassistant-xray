#!/usr/bin/with-contenv bashio

echo "Hello world!"

BEER=$(bashio::config 'beer')
WINE=$(bashio::config 'wine')
LIQOUR=$(bashio::config 'liquor')
NAME=$(bashio::config 'name')
YEAR=$(bashio::config 'year')

echo "option beer \"${BEER}\";"
echo "option wine \"${WINE}\";"
echo "option liquor \"${LIQOUR}\";"
echo "option name \"${NAME}\";"
echo "option year \"${YEAR}\";"
