# Use the official Node.js runtime as the base image
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json ./
RUN npm install

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Install dev dependencies for build
RUN npm install

# Build the application
RUN npm run build

# Production image with Caddy + Next.js
FROM caddy:2-alpine AS runner
WORKDIR /app

# Install Node.js in the Caddy image
RUN apk add --no-cache nodejs npm

# Copy Next.js application
COPY --from=builder /app/public ./public
RUN mkdir .next

# Copy built Next.js app
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Create startup script
COPY <<EOF /app/start.sh
#!/bin/sh
set -e

# Decode the base64 CA certificate to a proper PEM file
echo "Decoding CA certificate..."
base64 -d /app/certs/ca.crt > /app/certs/ca-decoded.crt

# Pre-create ACME directory structure to avoid write permission issues
echo "Pre-creating ACME directory structure..."
mkdir -p "/data/caddy/acme/vault.primary-vault.svc.cluster.local-8200-v1-intermediate-ca-acme-directory/users/admin@hashibank.com"
chmod -R 755 /data/caddy/acme

# Start Next.js in background
echo "Starting Next.js server..."
cd /app && NODE_ENV=production PORT=3000 HOSTNAME=0.0.0.0 node server.js &

# Wait for Next.js to start
sleep 5

# Start Caddy with the provided Caddyfile
echo "Starting Caddy server..."
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
EOF

# Make startup script executable
RUN chmod +x /app/start.sh

# Expose ports
EXPOSE 80 443

# Use the startup script as entrypoint
CMD ["/app/start.sh"]
