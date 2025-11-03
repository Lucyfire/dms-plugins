# Wallpaper Discovery

A DankMaterialShell widget that helps you find and download wallpapers.

![Wallpaper Discovery screenshot](screenshot.png)

## Features

> [!WARNING]  
> Currently all API keys are stored in plain text in the plugin settings.

Search and download wallpapers from:

- [**unsplash**](https://unsplash.com/)
You will need an API Key. Register at [unsplash.com/developers](https://unsplash.com/developers), create an [application](https://unsplash.com/oauth/applications) and generate an API key.
- [**pexels**](https://pexels.com/)
You will need an API Key. Register at [pexels.com/api/key](https://pexels.com/api/key) and generate an API key.

## Installation

### From Plugin Registry (Recommended)
```bash
dms plugins install wallpaperDiscovery
# or install using the plugins tab on DMS settings
```

### Manual Installation
```bash
# Copy plugin to DMS plugins directory
cp -r "wallpaperDiscovery" ~/.config/DankMaterialShell/plugins/

# Enable in DMS
# 1. Open Settings
# 2. Go to Plugins tab
# 3. Click "Scan for Plugins"
# 4. Toggle "Wallpaper Discover" to enable
# 5. Select Download location
# 6. Add you API keys
# 7. Go to Dank Bar and add the widget
```

## Configuration

Access settings via DMS Settings → Plugins → Wallpaper Discovery:

- **Download Location**: The directory the wallpapers will be saved, each 
provider will be in its own subdirectory.

## Requirements

- DankMaterialShell >= 0.2.4
- `curl`
- Wayland compositor (Niri, Hyprland, etc.)

## Compatibility

- **Compositors**: Niri and Hyprland
- **Distros**: Universal - works on any Linux distribution

## Contributing

Found a bug or want to add more providers? Open an issue or submit a pull request!

## License

MIT License - See LICENSE file for details

## Author

Created for the DankMaterialShell community

## Links

- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
- [Plugin Registry](https://github.com/AvengeMedia/dms-plugin-registry)
