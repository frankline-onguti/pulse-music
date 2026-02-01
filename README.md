# Pulse Music

Offline-first Android music intelligence app that scans local audio files, generates smart playlists, and provides listening analytics — no streaming, no cloud.

## Features

- 🎵 Local music scanning with MediaStore integration
- 📊 Smart playlist generation based on listening patterns
- 📈 Detailed listening analytics and insights
- 🎨 Modern Material Design UI
- 🔒 Complete privacy - no data leaves your device

## Architecture

Built with Flutter using:
- **Riverpod** for state management
- **SQLite** for local data persistence
- **Platform channels** for native Android integration
- **MediaStore API** for music file scanning

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Connect an Android device
4. Run `flutter run`

## Development Status

✅ **STEP 1 COMPLETE**: Local Music Scanner
- Android permissions handling
- MediaStore integration
- Song metadata extraction
- Platform channel communication

🚧 **Next Steps**:
- SQLite database schema
- Audio playback engine
- Smart playlist algorithms
- Analytics dashboard