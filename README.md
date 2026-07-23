docker build -t pi-sandbox .

docker run -it --add-host=host.docker.internal:host-gateway --network=host -v ~/Code/PROJECT:/home/piuser/workspace pi-sandbox

Requires pyproject.toml in project folder
