#!/bin/bash
# If paper.jar doesn't exist, download a stable 1.12.2 Paper jar automatically
if [ ! -f paper.jar ]; then
    echo "Downloading server core..."
    curl -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.12.2/builds/1618/downloads/paper-1.12.2-1618.jar
fi

java -Xmx1G -Xms1G -jar paper.jar nogui