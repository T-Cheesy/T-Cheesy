#!/bin/bash
# If paper.jar doesn't exist, download the fixed final 1.12.2 Paper build
if [ ! -f paper.jar ]; then
    echo "Downloading fixed server core..."
    curl -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.12.2/builds/1620/downloads/paper-1.12.2-1620.jar
fi

# Automatically generate and accept the EULA so the server doesn't halt
echo "eula=true" > eula.txt

# Start the server
java -Xmx1G -Xms1G -jar paper.jar nogui