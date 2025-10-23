#!/bin/bash

set -e # Exit on any error

# Create directories if don't exists
mkdir -p conf.d/nginx/ssl
mkdir -p conf.d/vscode
mkdir -p data/jupyter
mkdir -p data/vscode

# Generating SSL certificate"
echo "Generating SSL certificate"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout conf.d/nginx/ssl/key.pem \
    -out conf.d/nginx/ssl/cert.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=jupyter.localhost" \
    -addext "subjectAltName=DNS:vscode.localhost"

echo "SSL certificates generated successfully!"

# Create VS Code server configuration
echo "Creating VS Code server configuration..."
cat > conf.d/vscode/config.yaml << EOF
bind-addr: 0.0.0.0:8443
auth: password
password: code123
cert: false
EOF

echo "VS Code server configuration created!"

# Set persmisions
echo "Setting permissions..."
chmod 644 conf.d/nginx/ssl/cert.pem
chmod 600 conf.d/nginx/ssl/key.pem

# Set ownership for Jupyter data directory
sudo chown -R 1000:1000 data/jupyter data/vscode conf.d/vscode 2>/dev/null || {
    echo "Note: Could not change ownership, you may need to run this with sudo"
}

echo "Setup complete!"
echo ""
echo "Access via:"
echo "- Jupyter: https://jupyter.localhost"
echo "  Token: jupyter123"
echo "  Workspace: ./data/jupyter/"
echo "- VS Code: https://vscode.localhost"
echo "  Password: code123"
echo "  Workspace: ./data/vscode/"
echo ""
echo "Don't forget to:"
echo "1. Add these lines to your /etc/hosts file"
echo "  127.0.0.1 jupyter.localhost"
echo "  127.0.0.1 vscode.localhost"
echo "2. Run 'docker-compose up -d' to start the services"
echo "3. Accept the SSL warning in your browser (self-signed certificates)"
