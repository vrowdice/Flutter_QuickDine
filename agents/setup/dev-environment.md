# Development Environment

## Prerequisites

- Flutter SDK (`sdk: ^3.12.1`)
- Android Studio / Xcode
- HotPepper API key — [Recruit Web Service](https://webservice.recruit.co.jp/)
- Google Maps API key (Maps SDK Android + iOS)

## First-time setup

```powershell
cd c:\Users\Vrow\Desktop\Flutter_Dev\QuickDine
flutter pub get
copy assets\env.example assets\env
```

Edit `assets/env`:

```
HOTPEPPER_API_KEY=your_key_here
GOOGLE_MAPS_API_KEY=your_google_maps_key_here
```

- Android Maps key: `android/app/build.gradle.kts` reads `assets/env`
- iOS Maps key: `MapsKeyService` → `AppDelegate` MethodChannel

**Package ID:** `com.vrowdice.quick_dine`  
**Display name:** QuickDine

## Run

```powershell
flutter devices
flutter run
```

Splash shows Vrowdice logo then SearchScreen. Hot reload does **not** replay splash — full restart to test.

Outside Japan: use Tokyo default or map tap / Quick Pin before search.

## Commands

| Command | Purpose |
|---------|---------|
| `flutter pub get` | deps + l10n |
| `flutter analyze lib` | static analysis |
| `flutter run` | debug |
| `flutter run --release` | no debug banner; release perf |

PowerShell: chain with `;`.

## Troubleshooting

| Symptom | Check |
|---------|-------|
| Missing API key errors | `assets/env` from `env.example` |
| Blank map | Maps key, billing, SHA-1 (release) |
| Zero results | Japan coords; widen radius/count; try genre “All”; disable parking/private-room if too strict |
| Search timeout | Network; API key; 15s limit in `hotpepper_api.dart` |
| Phone link fails (Android) | `tel:` in manifest `<queries>` |
| Genre filter API error | Codes must match `search_genre.dart` exactly |

## Agent verification checklist

1. `flutter analyze lib` — zero errors
2. Splash → search panel (radius, count, parking/private-room filters, genre chips) → pill search → sheet + markers → detail (subtitle, call/web if data, budget)
3. Results sheet: drag extent (map padding tracks), random pick (left dice icon), close (right)
4. Show-on-map, favorites, Quick Pin, GPS, Settings + StudioCredit
5. HotPepper credits visible; new strings in all 3 ARB files

## Do not commit

`assets/env`, `build/`, `.dart_tool/`
