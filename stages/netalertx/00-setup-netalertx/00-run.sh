#!/bin/bash -e

on_chroot << 'CHROOT'
# Create NetAlertX directory
mkdir -p /opt/netalertx

# Create docker-compose.yml
cat > /opt/netalertx/docker-compose.yml << 'EOF'
services:
  netalertx:
    container_name: netalertx
    image: ${NETALERTX_IMAGE}
    network_mode: host
    restart: unless-stopped
    read_only: true
    volumes:
      - netalertx_data:/app/config
    environment:
      - TZ=UTC
      - PORT=20211
    cap_drop:
      - ALL
    cap_add:
      - NET_ADMIN
      - NET_RAW
      - NET_BIND_SERVICE
    deploy:
      resources:
        limits:
          memory: 2048M
        reservations:
          memory: 1024M

volumes:
  netalertx_data:
    driver: local
EOF

# Create systemd service
cat > /etc/systemd/system/netalertx.service << 'EOF'
[Unit]
Description=NetAlertX Network Scanner
Requires=docker.service
After=docker.service

[Service]
Type=simple
WorkingDirectory=/opt/netalertx
Environment="NETALERTX_IMAGE=${NETALERTX_IMAGE}"
ExecStartPre=-/usr/bin/docker compose pull
ExecStart=/usr/bin/docker compose up
ExecStop=/usr/bin/docker compose down
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl enable netalertx.service
CHROOT
