# Display Settings

A Hyprland DankMaterialShell plugin that allows you to disable/enable your displays.


![Display Settings screenshot](screenshot.png)

## Features

Registers 3 new ipc calls to dms

- `dms ipc call displaySettings toggle`
- `dms ipc call displaySettings open`
- `dms ipc call displaySettings close`

## Installation

```bash
# Copy plugin to DMS plugins directory
cp -r "displaySettings" ~/.config/DankMaterialShell/plugins/

# Enable in DMS plugins tab
# run `dms ipc call displaySettings open` to display the menu
```

## Configuration

None at the moment.

## Requirements

- DankMaterialShell >= 0.2.4
- Hyprland
    - a monitorv2 definiton in your hyprland.conf file.
    - For the monitor to be able to be turned off it needs to have an initial 
    disabled value eg:
    ```
    monitorv2 {
        output = DP-1
        disabled = 0
    }
    ```

## Compatibility

- **Compositors**: Hyprland
- **Distros**: Universal - works on any Linux distribution

## Contributing

Found a bug or want to add more features? Open an issue or submit a pull request!

## License

MIT License - See LICENSE file for details

