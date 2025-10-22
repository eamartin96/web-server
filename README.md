# Pre-requisites
Have Docker and Docker Compose installed

# Package Dependencies
openssl

# Instructions to deploy
1. Deploy Services
`docker-compose up -d`
2. Generate SSL certificates
`./generate_ssl_certificates.ssl`
3. Add `127.0.0.1   jupyter.localhost` to /etc/hosts file
4. Open your browser and write 'jupyter.localhost' and write the token
5. Accept the SSL warning
