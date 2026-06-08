#!/bin/bash
# If paper.jar doesn't exist, download the fixed final 1.12.2 Paper build
if [ ! -f paper.jar ]; then
    echo "Downloading fixed server core..."
    curl -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.12.2/builds/1620/downloads/paper-1.12.2-1620.jar
fi

# Automatically generate and accept the EULA so the server doesn't halt
echo "eula=true" > eula.txt

# Start the server restricted to Render's free tier limits (350MB heap, leaving room for system memory)
java -Xmx350M -Xms256M -XX:+UseG1GC -jar paper.jar nogui