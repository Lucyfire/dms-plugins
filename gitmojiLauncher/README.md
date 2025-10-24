# Gitmoji Launcher

This was the first feature I missed after moving to DMS, from [ulauncher gitmojis](https://github.com/aksdb/ulauncher-gitmoji)

A DankMaterialShell launcher plugin that provides quick access Gitmojis.

![Gitmoji Launcher Screenshot](screenshot.png)

## Features

- **Gitmojis** - Access to https://gitmoji.dev/

## Installation

### From Plugin Registry (Recommended)
```bash
# Coming soon - will be available via DMS plugin manager
```

### Manual Installation
```bash
# Copy plugin to DMS plugins directory
cp -r "Gitmoji Launcher" ~/.config/DankMaterialShell/plugins/

# Enable in DMS
# 1. Open Settings
# 2. Go to Plugins tab
# 3. Click "Scan for Plugins"
# 4. Toggle "Gitmoji Launcher" to enable
```

## Usage

### Default Trigger Mode
1. Open launcher (SUPER+Space)
2. Type `gm` followed by search query
3. Select item and press Enter to copy

### Always-On Mode
Configure in settings to show gitmojis items without a trigger prefix.

## Configuration

Access settings via DMS Settings → Plugins → Gitmoji Launcher:

- **Trigger**: Set custom trigger character (`gm`, `g`, etc.) or disable for always-on mode
- **No Trigger Mode**: Toggle to show items without trigger prefix

## Requirements

- DankMaterialShell >= 0.1.0
- `wl-copy` (from wl-clipboard package)
- Wayland compositor (Niri, Hyprland, etc.)

## Compatibility

- **Compositors**: Niri and Hyprland
- **Distros**: Universal - works on any Linux distribution

## Technical Details

- **Type**: Launcher plugin
- **Trigger**: `gm` (configurable)
- **Language**: QML (Qt Modeling Language)
- **Dependencies**: None (uses built-in character database)

## Contributing

Found a bug or want to add more characters? Open an issue or submit a pull request!

## License

MIT License - See LICENSE file for details

## Author

Created for the DankMaterialShell community

## Links

- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
- [Plugin Registry](https://github.com/AvengeMedia/dms-plugin-registry)
