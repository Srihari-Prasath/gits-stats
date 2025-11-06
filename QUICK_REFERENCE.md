# 🚀 GitTrack - Quick Reference

## Running the App

### Option 1: Using PowerShell Script

```powershell
.\run_app.ps1
```

### Option 2: Manual Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run on Chrome
flutter run -d chrome

# Build for release
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

---

## File Structure Overview

```
my_streak/
├── lib/
│   ├── config/
│   │   └── app_config.dart              # API endpoints, storage keys
│   ├── models/
│   │   ├── contribution_day.dart        # Single day contribution data
│   │   └── github_stats.dart            # User stats with streak calculation
│   ├── screens/
│   │   ├── login_screen.dart            # Authentication screen
│   │   └── home_screen.dart             # Main dashboard
│   ├── services/
│   │   ├── github_service.dart          # GitHub GraphQL API client
│   │   └── storage_service.dart         # Secure token storage
│   ├── theme/
│   │   └── app_theme.dart               # Colors, typography, theme
│   ├── widgets/
│   │   ├── contribution_graph.dart      # Heatmap visualization
│   │   ├── stats_card.dart              # Stats display widget
│   │   └── streak_card.dart             # Streak display widget
│   └── main.dart                        # App entry point
├── android/                              # Android configuration
├── ios/                                  # iOS configuration
├── web/                                  # Web configuration
├── test/                                 # Unit tests
├── pubspec.yaml                          # Dependencies
├── README.md                             # Project documentation
├── USAGE_GUIDE.md                        # User manual
├── DESIGN_SYSTEM.md                      # Design specifications
└── run_app.ps1                           # Quick run script
```

---

## Key Dependencies

| Package                  | Version | Purpose              |
| ------------------------ | ------- | -------------------- |
| `graphql_flutter`        | ^5.1.2  | GitHub GraphQL API   |
| `flutter_secure_storage` | ^9.0.0  | Secure token storage |
| `http`                   | ^1.1.0  | HTTP client          |
| `intl`                   | ^0.19.0 | Date formatting      |

---

## API Usage

### GitHub GraphQL Query

```graphql
query ($username: String!) {
  user(login: $username) {
    name
    contributionsCollection {
      contributionCalendar {
        totalContributions
        weeks {
          contributionDays {
            date
            contributionCount
          }
        }
      }
    }
  }
}
```

### Required Token Scopes

- `read:user` - Read user profile
- `repo` - Access contribution data

---

## Common Tasks

### Update Dependencies

```bash
flutter pub get
flutter pub upgrade
```

### Check for Outdated Packages

```bash
flutter pub outdated
```

### Format Code

```bash
flutter format .
```

### Analyze Code

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

### Clean Build

```bash
flutter clean
flutter pub get
flutter run
```

---

## Troubleshooting

### Build Issues

```bash
# Clean and rebuild
flutter clean
flutter pub get
rm -rf build/
flutter run
```

### iOS Specific

```bash
cd ios
pod install
cd ..
flutter run
```

### Android Specific

```bash
cd android
./gradlew clean
cd ..
flutter run
```

### Storage Issues (Token not saving)

- Check permissions in AndroidManifest.xml
- Check iOS entitlements
- Try clearing app data and re-login

---

## Configuration Changes

### Change App Name

1. Edit `pubspec.yaml` - Change `name: my_streak`
2. Update `lib/config/app_config.dart` - Change `appName`
3. Update platform-specific files:
   - **Android**: `android/app/src/main/AndroidManifest.xml`
   - **iOS**: `ios/Runner/Info.plist`

### Change App Icon

```bash
# Install flutter_launcher_icons
flutter pub add dev:flutter_launcher_icons

# Add configuration to pubspec.yaml
# Run generator
flutter pub run flutter_launcher_icons:main
```

### Change Theme Colors

Edit `lib/theme/app_theme.dart`:

- `primaryDark` - Background color
- `accentBlue` - Primary accent
- `accentPurple` - Secondary accent
- `accentOrange` - Tertiary accent

---

## Testing Credentials

### Test with Your GitHub Account

1. Use your real GitHub username
2. Generate a test token with minimal permissions
3. Revoke token when done testing

### Mock Data (for development)

Edit `lib/services/github_service.dart` to return mock data

---

## Performance Optimization

### Enable Performance Overlay

```dart
// In main.dart
MaterialApp(
  showPerformanceOverlay: true,
  // ...
)
```

### Check App Size

```bash
flutter build apk --analyze-size
flutter build appbundle --analyze-size
```

### Profile Mode

```bash
flutter run --profile
```

---

## Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Test on multiple devices
- [ ] Test with real GitHub data
- [ ] Check for errors (`flutter analyze`)
- [ ] Format code (`flutter format .`)
- [ ] Update README.md
- [ ] Generate release builds
- [ ] Test release builds
- [ ] Create git tag
- [ ] Update changelog

---

## Useful Commands Cheat Sheet

```bash
# Development
flutter run                    # Run app
flutter run --release         # Run in release mode
flutter run -d chrome         # Run on Chrome
flutter hot reload           # Hot reload (r in terminal)
flutter hot restart          # Hot restart (R in terminal)

# Build
flutter build apk            # Build Android APK
flutter build appbundle      # Build Android App Bundle
flutter build ios            # Build iOS
flutter build web            # Build Web

# Maintenance
flutter clean                # Clean build files
flutter pub get              # Get dependencies
flutter pub upgrade          # Upgrade dependencies
flutter doctor               # Check installation
flutter devices              # List devices

# Code Quality
flutter analyze              # Analyze code
flutter test                 # Run tests
flutter format .             # Format code
```

---

## Environment Variables (Optional)

Create `.env` file:

```env
GITHUB_TOKEN=your_token_here
GITHUB_USERNAME=your_username
```

**Note**: Don't commit this file! Add to `.gitignore`

---

## Git Workflow

```bash
# Initial setup
git init
git add .
git commit -m "Initial commit: GitTrack app"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main

# Regular workflow
git add .
git commit -m "Your commit message"
git push
```

---

## Support & Resources

- **Flutter Docs**: https://flutter.dev/docs
- **GitHub GraphQL API**: https://docs.github.com/graphql
- **GraphQL Flutter**: https://pub.dev/packages/graphql_flutter
- **Flutter Secure Storage**: https://pub.dev/packages/flutter_secure_storage

---

**Quick Start**: `.\run_app.ps1` or `flutter run`

**Version**: 1.0.0
**Last Updated**: November 2025
