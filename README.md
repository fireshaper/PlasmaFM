# Roam Radio

A KDE Plasma 6 widget that plays random internet radio stations from [radio-browser.info](https://radio-browser.info). Inspired by RoamFM, this plasmoid lets you discover and enjoy radio stations from around the world with a single click.

## Features

- 🎲 **One-Click Roaming**: Instantly play a random radio station
- ⏯️ **Playback Controls**: Play, pause, and skip to the next random station
- ⭐ **Favorites**: Save your favorite stations for quick access
- 🌍 **Station Info**: View station name, country, bitrate, and codec
- 🔇 **Language Filters**: Exclude stations in specific languages
- 🎚️ **Quality Control**: Set minimum bitrate preference (64-320 kbps)
- 🔄 **Auto-Retry**: Automatically skip dead streams and try the next station
- 💾 **Persistence**: Favorites and settings are saved across sessions

## Installation

### Prerequisites

- KDE Plasma 6
- `plasmapkg2` (usually included with plasma-framework)
- Qt Multimedia support

### Install

```bash
cd PlasmaFM
chmod +x install.sh
./install.sh
```

### Add to Desktop/Panel

1. Right-click on your desktop or panel
2. Select **Add Widgets...**
3. Search for **PlasmaFM Radio**
4. Drag it to your desktop or panel

## Development

### Project Structure

```
PlasmaFM/
├── metadata.json                 # Plasma 6 widget metadata
├── contents/
│   ├── config/
│   │   ├── main.xml             # Configuration schema
│   │   └── config.qml           # Config UI definition
│   ├── ui/
│   │   ├── main.qml             # Main widget logic
│   │   ├── CompactRepresentation.qml
│   │   ├── FullRepresentation.qml
│   │   └── configGeneral.qml    # Settings UI
│   └── code/
│       ├── radiobrowser.js      # Radio Browser API integration
│       └── favorites.js         # Favorites management
├── install.sh                   # Installation script
├── dev-install.sh              # Development reinstall script
└── README.md
```

### Development Workflow

1. **Make changes** to QML or JavaScript files
2. **Reinstall** the widget:
   ```bash
   chmod +x dev-install.sh
   ./dev-install.sh
   ```
3. **Test** the updated widget

### Manual Installation Commands

```bash
# Install
plasmapkg2 --install /path/to/PlasmaFM

# Upgrade (reinstall)
plasmapkg2 --upgrade /path/to/PlasmaFM

# Remove
plasmapkg2 --remove org.kde.plasma.roamradio

# List installed widgets
plasmapkg2 --list
```

### Debugging

View plasmoid logs:
```bash
journalctl -f | grep plasmashell
```

Or check the system logs:
```bash
tail -f ~/.xsession-errors
```

Restart plasmashell:
```bash
killall plasmashell; kstart5 plasmashell
```

## Usage

### Basic Controls

- **Random Button**: Play a random station from the radio-browser.info database
- **Play/Pause**: Control playback of the current station
- **Star Button**: Add/remove the current station from favorites

### Favorites

1. Play a station you like
2. Click the **Star** button to add it to favorites
3. Access favorites from the **Favorites** tab
4. Click **Play** on any favorite to start playback
5. Remove favorites with the **Delete** button

### Language Filters

1. Open the widget and go to the **Filters** tab
2. Enter a language to exclude (e.g., "english", "spanish")
3. Click **Add** or press Enter
4. The widget will avoid stations in those languages when roaming
5. Remove filters by clicking the **X** on the language tag

### Quality Settings

- Adjust the **Minimum Bitrate** slider in the Filters tab
- Higher values prefer better quality streams (but may reduce station variety)
- Range: 64 kbps to 320 kbps

### Configuration

Right-click the widget → **Configure Roam Radio**

- **Minimum Bitrate**: Set quality preference
- **Skip Dead Stations**: Auto-retry if stream fails
- **Max Retries**: Number of retry attempts (1-10)

## How It Works

### Radio Browser API

The widget uses the [Radio Browser API](https://api.radio-browser.info/) to fetch station data:

- Fetches 100 random stations matching your filters
- Caches stations locally to reduce API calls
- Applies language and bitrate filters
- Increments station click counter when playing

### Audio Playback

- Uses Qt Multimedia's `Audio` element for streaming
- Supports common formats: MP3, AAC, OGG, etc.
- Handles stream errors with automatic retry logic
- Pauses/resumes playback seamlessly

### Data Persistence

- **Favorites**: Stored in Plasma configuration as JSON
- **Filters**: Language exclusions saved to config
- **Settings**: Bitrate and retry preferences persist across sessions

## Troubleshooting

### Widget doesn't appear after installation

Try restarting plasmashell:
```bash
killall plasmashell; kstart5 plasmashell
```

### No sound / Stream won't play

1. Check your system audio settings
2. Verify Qt Multimedia is installed: `qt6-multimedia` or `qt5-multimedia`
3. Try a different station (some streams may be offline)
4. Enable "Skip Dead Stations" in settings

### Stations are all in one language

Add language filters in the **Filters** tab to exclude unwanted languages.

### Widget crashes or behaves unexpectedly

Check logs:
```bash
journalctl -f | grep plasmashell
```

Report issues with log output.

## Credits

- **Radio Database**: [radio-browser.info](https://radio-browser.info)
- **Inspiration**: [RoamFM](https://roamfm.com)
- **Framework**: KDE Plasma 6

## License

GPL-2.0+

## Contributing

Contributions welcome! Feel free to:

- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

---

**Enjoy discovering radio stations from around the world! 🌍📻**
