# Development Environment

## Prerequisites

- Flutter SDK (project: `sdk: ^3.12.1` in `pubspec.yaml`)
- Android Studio / Xcode (mobile targets)
- HotPepper API key ([Recruit Web Service](https://webservice.recruit.co.jp/))
- Google Maps API key (Maps SDK for Android/iOS enabled)

## First-time setup

### 1. Clone & dependencies

```powershell
cd c:\Users\Vrow\Desktop\Flutter_Dev\QuickDine
flutter pub get
```

This also runs `flutter gen-l10n` (via `flutter: generate: true`).

### 2. API keys (`assets/env`)

File is **gitignored**. Copy the template and fill in keys:

```powershell
copy assets\env.example assets\env
```

Edit `assets/env`:

```
HOTPEPPER_API_KEY=your_key_here
GOOGLE_MAPS_API_KEY=your_google_maps_key_here
```

- Confirm `pubspec.yaml` lists `assets: - assets/env`
- `main.dart` calls `dotenv.load(fileName: ApiConstants.envAssetPath)`
- **Android Maps key** is injected at build time from the same file (`android/app/build.gradle.kts`) — no manual Manifest edit
- **iOS Maps key** is sent at runtime via `MapsKeyService` → `AppDelegate` MethodChannel

### 3. Run

```powershell
flutter devices
flutter run
```

Verify map and API on emulator or device. On first open the app tries GPS (falls back to Tokyo). Outside Japan, use map tap or save a Quick Pin.

**Package ID:** `com.vrowdice.quick_dine`

## Common commands

| Command | Purpose |
|---------|---------|
| `flutter pub get` | Sync dependencies + regenerate l10n |
| `flutter analyze lib` | Static analysis |
| `flutter run` | Debug run |
| `flutter build apk` | Android APK |
| `flutter build ios` | iOS (requires macOS) |

PowerShell: chain commands with `;` (`cd path; flutter run`).

## Troubleshooting

| Symptom | Check |
|---------|-------|
| `assets/env에 HOTPEPPER_API_KEY를 설정` | Copy `env.example` → `env`, set real keys |
| `assets/env에 GOOGLE_MAPS_API_KEY를 설정` | Same; Android Gradle reads this file at build time |
| Gray/blank map | Key in `assets/env`, Cloud Console Maps SDK enabled, billing/limits, SHA-1 for release |
| GPS error SnackBar | Device GPS on, app location permission, iOS `Info.plist` usage strings |
| Zero search results | Coordinates in Japan; widen radius or increase max count; try another map point |
| HTTP error | Network, API key validity, daily quota |
| Missing translations / l10n errors | All keys in `app_en.arb` must exist in `app_ko.arb` / `app_ja.arb`; run `flutter pub get` |
| Language not changing | `SettingsService.setLocaleCode`, `app.dart` `ListenableBuilder` |

## What not to commit

- `assets/env` (real keys)
- `build/`, `.dart_tool/`
- IDE settings (optional)

`assets/env` is in `.gitignore` — run `git status` before committing.

## Agent verification checklist

After code changes, when possible:

1. `flutter analyze lib` — zero errors
2. Manual pass: AppBar favorites/settings; floating radius/count; bottom search pill; search → map markers + bottom sheet list → detail; sheet drag/close/reopen; show-on-map; Quick Pin bounce; GPS on startup; Settings radius + max count + language
3. Credit bar and image credits still visible on API screens
4. New UI strings added to all three ARB files
