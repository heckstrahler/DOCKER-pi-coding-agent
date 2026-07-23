docker build -t pi-sandbox .

docker run -it --add-host=host.docker.internal:host-gateway --network=host -v ~/Code/pynetblueprintv3/PyNetBlueprint/:/home/piuser/workspace pi-sandbox
