# RPi NetAlertX Image Builder

Automated Raspberry Pi OS image builder with Docker and NetAlertX pre-configured for Zero 2W and newer devices.

## Features

- 🔧 **Automated GitHub Actions workflow** - Builds images automatically
- 🐧 **64-bit Raspberry Pi OS** - Optimized for Pi Zero 2W and newer
- 🐳 **Docker & Docker Compose** - Pre-installed and enabled
- 📡 **NetAlertX** - Production or dev image from GitHub Container Registry pre-pulled and ready
- 📦 **Compressed releases** - Images compressed with gzip, compatible with Raspberry Pi Imager
- 🔐 **Default credentials** - Username: `pi`, Password: `raspberry` (change on first login)
- 🚀 **Fast boot** - NetAlertX starts immediately, no waiting for downloads
- 🔄 **Production or Dev** - Choose between stable production or latest dev builds

## Quick Start

### Download Pre-built Image

1. Go to the [Releases](../../releases) page and download the latest `.img.gz` file
2. Flash to SD card using Raspberry Pi Imager:

**In Raspberry Pi Imager:**
1. Select your Raspberry Pi
2. Select the downloaded image: Operating System -> Use Custom -> the downloaded file
3. Select the SD card to flash
4. Press Next and proceed through the process

3. Boot your Raspberry Pi
4. Login with username `pi` and password `raspberry`
5. **Change the default password immediately** using the `passwd` command
6. NetAlertX will start automatically and be accessible at `http://<pi-ip>:20211` within seconds

### Build Your Own

The workflow is fully automated:
- **Push to main** - Builds with production image (ghcr.io/jokob-sk/netalertx:latest)
- **Manual trigger** - Choose between production or dev variant:
  - Production: `ghcr.io/jokob-sk/netalertx:latest` (stable)
  - Dev: `ghcr.io/jokob-sk/netalertx-dev:latest` (latest features)

To trigger manually with dev image:
1. Go to Actions tab
2. Select "Build RPi NetAlertX Image" workflow
3. Click "Run workflow"
4. Choose "dev" from the dropdown
5. Click "Run workflow"

## Configuration

### Image Specifications

- **Base OS**: Raspberry Pi OS (64-bit)
- **Device Support**: Raspberry Pi 3, 3+, 4, 400, Zero 2W, 5
- **Boot Partition**: 256MB
- **Root Partition**: 2GB (auto-expands on first boot)
- **Docker**: Latest from Docker CE repository
- **Docker Compose**: Included as Docker plugin
- **Default User**: pi
- **Default Password**: raspberry

### Customization

You can customize the image by modifying:

- `config/netalertx.yaml` - Main configuration file
- `layer/netalertx.yaml` - NetAlertX layer configuration
- `.github/workflows/build-image.yml` - Build workflow

## How It Works

The build process uses [rpi-image-gen](https://github.com/raspberrypi/rpi-image-gen), the official Raspberry Pi Foundation tool for creating custom images:

1. GitHub Actions runner installs dependencies (qemu, mmdebstrap, etc.)
2. Clones rpi-image-gen repository
3. Applies custom configuration and layers
4. Builds the image using Raspberry Pi OS base
5. Adds Docker layer (`docker-debian-bookworm`)
6. Applies NetAlertX custom layer:
   - Enables docker.service
   - Creates docker-compose.yml at /opt/netalertx
   - Pre-pulls NetAlertX Docker image from GitHub Container Registry
   - Uses production (ghcr.io/jokob-sk/netalertx:latest) or dev (ghcr.io/jokob-sk/netalertx-dev:latest) variant
   - Creates systemd service to run NetAlertX with Docker Compose
   - Sets default password for pi user
   - Configures auto-start on boot
7. Compresses the final image with gzip
8. Creates a GitHub Release with the compressed image

## NetAlertX Configuration

After booting the image:

1. NetAlertX starts automatically within seconds (image is pre-pulled, no downloads needed)
2. Access the web interface at `http://<raspberry-pi-ip>:20211`
3. Configuration and data are stored at `/opt/netalertx/data` on the Pi
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

- **Default password is `raspberry`** - Change it immediately on first login using `passwd`
- Docker service runs automatically and NetAlertX has host network access
- NetAlertX data is persisted at `/opt/netalertx/data`

## License

This project configuration is provided as-is. Raspberry Pi OS and related software have their own licenses.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
