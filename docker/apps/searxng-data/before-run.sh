cp searxng/settings.yml  /opt/data-docker/searxng/data
sed -i "s|ultrasecretkey|$(openssl rand -hex 32)|g" /opt/data-docker/searxng/data/settings.yml
docker compose  --env-file /opt/data-docker/searxng/.env  down -v
docker compose --env-file /opt/data-docker/searxng/.env up -d

