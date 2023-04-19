# Use an appropriate base image, e.g., a lightweight Linux distribution
FROM debian:bookworm-slim

# Install the GnuCOBOL compiler and NGINX
RUN apt-get update
RUN apt-get install -y gnucobol nginx

# Set the working directory
WORKDIR /app

# Copy your COBOL source code into the container
COPY hello_world.cbl /app

# Compile your COBOL application
RUN cobc -x -o hello_world hello_world.cbl

# Run your COBOL application to generate the "Hello world!" file
RUN ./hello_world

# Configure NGINX to serve the generated file
RUN echo "server { listen 80; location / { root /app; } }" > /etc/nginx/sites-enabled/default

# Set the entry point for your application
CMD ["nginx", "-g", "daemon off;"]
