# Use a lightweight Java 17 image (perfect for Paper/Spigot 1.12.2 setups)
FROM openjdk:17-slim

# Install curl so your start.sh script can auto-download the server file if needed
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the server container
WORKDIR /app

# Copy all your server files from GitHub into the container
COPY . .

# Give your startup script permission to run
RUN chmod +x start.sh

# Expose port 8080 for Eaglercraft network traffic
EXPOSE 8080

# Tell the container to launch your startup script when it starts
CMD ["./start.sh"]