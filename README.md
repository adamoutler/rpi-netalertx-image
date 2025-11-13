# RPi NetAlertX Image Builder

Automated Raspberry Pi OS image builder with Docker and NetAlertX pre-configured for Zero 2W and newer devices.

## Features

- 🔧 **Automated GitHub Actions workflow** - Builds images automatically
- 🐧 **64-bit Raspberry Pi OS** (Debian Bookworm) - Optimized for Pi Zero 2W+
- 🐳 **Docker & Docker Compose** - Pre-installed and enabled
- 📡 **NetAlertX** - Automatically pulled on first boot from `jokob-sk/netalertx:latest`
- 📦 **Compressed releases** - Images compressed with xz for faster downloads
- 🔐 **Optional user credentials** - Support for GitHub Secrets or default configuration

## Quick Start

### Option 1: Download Pre-built Image

1. Go to the [Releases](../../releases) page
2. Download the latest `netalertx-rpi.img.xz`
3. Extract: `xz -d netalertx-rpi.img.xz`
4. Flash to SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) or `dd`:
   ```bash
   sudo dd if=netalertx-rpi.img of=/dev/sdX bs=4M status=progress && sync
   ```
5. Boot your Raspberry Pi
6. NetAlertX Docker image will be pulled automatically on first boot

### Option 2: Build Your Own

1. Fork this repository
2. (Optional) Set up GitHub Secrets for custom credentials:
   - `FIRST_USER_NAME` - Default: `pi`
   - `FIRST_USER_PASS` - Default: empty (you'll need to configure auth manually)
3. Push to `main` branch or manually trigger the workflow
4. Download the generated image from the Releases page

## Configuration

### Image Specifications

- **Base OS**: Debian Bookworm (64-bit)
- **Device Support**: Raspberry Pi 3, 3+, 4, 400, Zero 2W, 5
- **Boot Partition**: 256MB
- **Root Partition**: 2GB (will expand on first boot)
- **Docker**: Latest from Docker CE repository
- **Docker Compose**: Included as Docker plugin

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
4. Builds the image using `bookworm-minbase` base layer
5. Adds Docker layer (`docker-debian-bookworm`)
6. Applies NetAlertX custom layer:
   - Enables docker.service
   - Creates systemd service to pull NetAlertX on first boot
   - Configures auto-start
7. Compresses the final image with xz
8. Creates a GitHub Release with the compressed image

## NetAlertX Configuration

After booting the image:

1. NetAlertX will be automatically pulled on first boot (this may take a few minutes)
2. You can start NetAlertX using:
   ```bash
   docker run -d --name netalertx jokob-sk/netalertx:latest
   ```
3. Or create your own docker-compose configuration

## Supported Devices

- Raspberry Pi Zero 2 W
- Raspberry Pi 3, 3A+, 3B+
- Raspberry Pi 4, 4B
- Raspberry Pi 400
- Raspberry Pi 5

## Security Notes

- Default images have login disabled by default (following rpi-image-gen defaults)
- Configure SSH keys or use the Raspberry Pi Imager to set credentials before first boot
- Or set `FIRST_USER_NAME` and `FIRST_USER_PASS` secrets for automated builds

## License

This project configuration is provided as-is. Raspberry Pi OS and related software have their own licenses.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
