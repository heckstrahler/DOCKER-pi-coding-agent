docker build -t pi-sandbox .

docker run -it --add-host=host.docker.internal:host-gateway --network=host \
  -e EXT_BASE_URL="<external-base-url>" \
  -e EXT_API_KEY="<external-api-key>" \
  -v ~/Code/PROJECT:/home/piuser/workspace pi-sandbox

Requires pyproject.toml in project folder
