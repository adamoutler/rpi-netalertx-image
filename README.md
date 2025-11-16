# RPi NetAlertX Image Builder

Automated Raspberry Pi OS image builder with Docker and NetAlertX pre-configured for Zero 2W and newer devices.

## Features

- 🔧 **Automated GitHub Actions workflow** - Builds images automatically
- 🐧 **64-bit Raspberry Pi OS** - Optimized for Pi Zero 2W and newer
- 🐳 **Docker & Docker Compose** - Pre-installed and enabled
- 📡 **NetAlertX** - Dev or production image from GitHub Container Registry pre-pulled and ready
- 📦 **Compressed releases** - Images compressed with gzip, compatible with Raspberry Pi Imager
- 🔐 **RPi Imager configuration** - Use Raspberry Pi Imager to set username, password, and WiFi
- 🚀 **Fast boot** - NetAlertX starts immediately, no waiting for downloads
- 🔄 **Dev or Production** - Dev builds by default, choose production if needed
- 🔒 **Read-only container** - Secure configuration with read-only filesystem

## Quick Start

### Download Pre-built Image

1. Go to the [Releases](../../releases) page and download the latest `.img.gz` file
2. Flash to SD card using Raspberry Pi Imager:

**In Raspberry Pi Imager:**
1. Select your Raspberry Pi
2. Select the downloaded image: Operating System -> Use Custom -> the downloaded file
3. Select the SD card to flash
4. **IMPORTANT**: Click the gear icon (⚙️) or press Ctrl+Shift+X to configure:
   - **Set username and password** (strongly recommended to override defaults)
   - Configure WiFi credentials (optional)
   - Configure hostname (optional)
   - Enable SSH if desired (optional)
5. Press Next and proceed through the process

3. Boot your Raspberry Pi
4. Login with the username/password you configured in RPi Imager (or use defaults: pi/raspberry)
5. NetAlertX will start automatically and be accessible at `http://<pi-ip>:20211` within seconds

### Build Your Own

The workflow is fully automated:
- **Push to main** - Builds with dev image (ghcr.io/jokob-sk/netalertx-dev:latest) by default
- **Manual trigger** - Choose between dev or production variant:
  - Dev: `ghcr.io/jokob-sk/netalertx-dev:latest` (latest features, default)
  - Production: `ghcr.io/jokob-sk/netalertx:latest` (stable)

To trigger manually with production image:
1. Go to Actions tab
2. Select "Build RPi NetAlertX Image" workflow
3. Click "Run workflow"
4. Choose "production" from the dropdown
5. Click "Run workflow"

## Configuration

### Image Specifications

- **Base OS**: Raspberry Pi OS (64-bit)
- **Device Support**: Raspberry Pi 3, 3+, 4, 400, Zero 2W, 5
- **Boot Partition**: 256MB
- **Root Partition**: 2GB (auto-expands on first boot)
- **Docker**: Latest from Docker CE repository
- **Docker Compose**: Included as Docker plugin
- **Authentication**: Default user: `pi`, password: `raspberry`
- **IMPORTANT**: Use the Raspberry Pi Imager gear icon (⚙️) to set your own username, password, and WiFi. This will override the default.
- **First Boot**: Raspberry Pi Imager settings are applied automatically (username, password, WiFi, hostname, SSH)
- **NetAlertX Data**: Stored in Docker named volume `netalertx_data`

### Customization

You can customize the image by modifying:

- `.github/workflows/build-image.yml` - Build workflow and custom stage configuration

## How It Works

The build process uses [pi-gen-action](https://github.com/usimd/pi-gen-action), a GitHub Action wrapper for the official Raspberry Pi Foundation's pi-gen tool:

1. GitHub Actions runner prepares custom stage for NetAlertX
2. Custom stage includes two substages:
   - Install Docker using official Docker installation script
   - Setup NetAlertX with docker-compose and systemd service
3. Builds the image using Raspberry Pi OS base with custom stages
4. NetAlertX configuration:
   - Creates docker-compose.yml at /opt/netalertx with read-only container
   - Uses dev (ghcr.io/jokob-sk/netalertx-dev:latest) or production (ghcr.io/jokob-sk/netalertx:latest) variant
   - Creates systemd service to run NetAlertX with Docker Compose
   - Uses Docker named volume for persistent data
   - Configures auto-start on boot
5. Compresses the final image with gzip
6. Creates a GitHub Release with the compressed image

## NetAlertX Configuration

After booting the image:

1. NetAlertX starts automatically within seconds (image is pre-pulled, no downloads needed)
2. Access the web interface at `http://<raspberry-pi-ip>:20211`
3. Configuration and data are stored in Docker named volume `netalertx_data`
4. To manage the service:
   ```bash
   # Check status
   sudo systemctl status netalertx
   
   # View logs
   sudo docker logs netalertx
   
   # Restart service
   sudo systemctl restart netalertx
   
   # Pull latest image and restart
   cd /opt/netalertx
   sudo docker compose pull
   sudo docker compose up -d
   ```
5. The docker-compose configuration is at `/opt/netalertx/docker-compose.yml`

## Supported Devices

- Raspberry Pi Zero 2 W
- Raspberry Pi 3, 3A+, 3B+
- Raspberry Pi 4, 4B
- Raspberry Pi 400
- Raspberry Pi 5

## Security Notes

- **Configure credentials in Raspberry Pi Imager** - The image has defaults (pi/raspberry), but you should override them using Raspberry Pi Imager configuration
- **Read-only container** - NetAlertX runs in a read-only container for enhanced security
- Docker service runs automatically and NetAlertX has host network access for ARP scanning
- NetAlertX data is persisted in Docker named volume `netalertx_data`

## License

This project configuration is provided as-is. Raspberry Pi OS and related software have their own licenses.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
