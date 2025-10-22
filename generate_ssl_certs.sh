#!/bin/bash

set -e # Exit on any error

# Create directories if don't exists
mkdir -p conf.d/nginx/ssl
mkdir -p data/jupyter

# Generating SSL certificate for jupyter.localhost
echo "Generating SSL certificate for jupyter.localhost"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout conf.d/nginx/ssl/key.pem \
    -out conf.d/nginx/ssl/cert.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=jupyter.localhost"

echo "SSL certificates generated successfully!"

# Set persmisions
echo "Setting permissions..."
chmod 644 conf.d/nginx/ssl/cert.pem
chmod 600 conf.d/nginx/ssl/key.pem

# Set ownership for Jupyter data directory
sudo chown -R 1000:1000 data/jupyter 2>/dev/null || {
    echo "Note: Could not change ownership of data/jupyter, you may need to run this with sudo"
}

echo "Setup complete!"
echo ""
echo "Custom IP Configuration"
echo "- Nginx: 172.18.0.2"
echo "- Jupyter: 172.18.0.3"
echo ""
echo "Access via https://jupyter.localhost"
echo "Token: jupyter123"
echo ""
echo "Don't forget to:"
echo "1. Add '127.0.0.1 jupyter.localhost' to your /etc/hosts file"
echo "2. Run 'docker-compose up -d' to start the services"
echo "3. Accept the SSL warning in your browser (self-signed certificates)"

