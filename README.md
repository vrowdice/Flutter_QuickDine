# QuickDine

**English** | [日本語](README.ja.md)

A Flutter app to discover nearby restaurants in **Japan** using the [HotPepper Gourmet Search API](https://webservice.recruit.co.jp/hotpepper/gourmet/v1/) and **Google Maps**. Pick a search point on the map, filter results, and browse list and detail views—with favorites, quick pins, and multi-language UI.

![Flutter](https://img.shields.io/badge/Flutter-3.12+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)

---

## Features

| Area | What it does |
|------|----------------|
| **Map search** | Full-screen Google Map; tap to set search center; GPS for current location |
| **HotPepper search** | Radius 300 m–3000 m (5 steps), max results 10–100 per request |
| **Filters** | Genre (e.g. izakaya, ramen), parking, private room |
| **Results UX** | Shop markers on map + draggable bottom sheet list (name, access, thumbnail) |
| **Random pick** | Dice button on the results sheet — opens a random shop’s detail page |
| **Detail** | Photo, genre/catch copy, budget, address, hours, access; call & web links |
| **Quick pins** | Save named locations and jump back with one tap |
| **Favorites** | Persist shops locally (`shared_preferences`) |
| **Settings** | Default radius/count, language (system / ko / ja / en), clear data |
| **Compliance** | HotPepper credit bar and image attribution on API screens |
| **i18n & fonts** | Korean, Japanese, English UI; Noto Sans / Noto Sans KR / Noto Sans JP |

> **Note:** HotPepper only returns data for **coordinates in Japan**. When testing outside Japan, pan the map to a Japanese location (e.g. Tokyo Station) or use a quick pin.

---

## Screens

```
Splash → Search (map hub) → Detail
              ↓
         Favorites / Settings
```

- **Search** — Map, floating search panel, pill search button, results sheet, quick-pin panel  
- **Detail** — Shop info, favorite toggle, show on map, phone / HotPepper web  
- **Favorites** — Saved shops  
- **Settings** — Defaults, locale, data reset  

---

## Tech stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter / Dart ^3.12.1 |
| APIs | HotPepper Gourmet Search, Google Maps SDK |
| Packages | `http`, `geolocator`, `google_maps_flutter`, `flutter_dotenv`, `shared_preferences`, `url_launcher`, `google_fonts` |
| Local storage | `shared_preferences` (favorites, quick pins, settings) |
| Package ID | `com.vrowdice.quick_dine` |

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.12.1)
- Android Studio and/or Xcode for device builds
- [HotPepper API key](https://webservice.recruit.co.jp/) (Recruit Web Service)
- [Google Maps API key](https://console.cloud.google.com/) with **Maps SDK for Android** and **Maps SDK for iOS** enabled

---

## Setup

### 1. Clone and install dependencies

```bash
git clone <your-repo-url>
cd QuickDine
flutter pub get
```

### 2. Configure API keys

`assets/env` is **gitignored**. Create it from the template:

**Windows (PowerShell)**

```powershell
copy assets\env.example assets\env
```

**macOS / Linux**

```bash
cp assets/env.example assets/env
```

Edit `assets/env`:

```env
HOTPEPPER_API_KEY=your_hotpepper_key
GOOGLE_MAPS_API_KEY=your_google_maps_key
```

| Key | Used for |
|-----|----------|
| `HOTPEPPER_API_KEY` | Gourmet Search API (`HotPepperApi`) |
| `GOOGLE_MAPS_API_KEY` | Map display |

**Google Maps key wiring**

- **Android** — Gradle reads `assets/env` at build time and injects the key into `AndroidManifest.xml` via `manifestPlaceholders`.
- **iOS** — `MapsKeyService` passes the key from `assets/env` to native code at startup.

You only need to maintain **`assets/env`** for local development; do not commit real keys.

### 3. Run the app

```bash
flutter devices
flutter run
```

Grant **location permission** when prompted for GPS search.

---

## Project structure

```
lib/
  main.dart                 # Entry point
  app.dart                  # MaterialApp, theme, locale
  screens/                  # splash, search, detail, favorites, settings
  widgets/                  # map, bottom sheet, credits, search UI
  services/                 # API, GPS, favorites, quick pins, settings, bootstrap
  models/                   # Shop, QuickPin
  constants/                # API URLs, radius, count, genre codes
  theme/                    # Brand colors + Noto fonts
  l10n/                     # Generated localizations (ko / ja / en)
assets/
  env.example               # API key template (committed)
  env                       # Real keys (gitignored)
  images/                   # App icon, studio logo
agents/                     # Agent harness docs (English)
簡易仕様書_QuickDine.txt      # Detailed spec (Japanese)
```

---

## Demo flow (for reviewers)

1. Launch app → splash → search screen (map loads).  
2. Move map to a **Japan** coordinate (or allow GPS if in Japan).  
3. Set radius / max count; optional genre or parking / private-room filters.  
4. Tap the bottom **Search** pill → results on map + bottom sheet.
5. Optional: tap the **dice** icon (top-left of sheet) for a random shop → detail.
6. Open a shop → detail; try **Call** / **Web** if available.
7. Add to favorites; open **Settings** to switch language.

---

## HotPepper credit (required)

Screens that display HotPepper data or images include mandatory attribution per the [Recruit Web Service terms](https://webservice.recruit.co.jp/). Do not remove `ScreenWithCredit` or `HotPepperImageCredit` when modifying UI.

---

## Troubleshooting

| Issue | Check |
|-------|--------|
| HotPepper key error | `assets/env` exists; `HOTPEPPER_API_KEY` is set and not a placeholder |
| Blank / gray map | Same `GOOGLE_MAPS_API_KEY` in `assets/env`; Maps SDK enabled; billing on GCP |
| Zero results | Search point is in Japan; try a wider radius |
| GPS errors | Location services on; app permission granted; iOS `Info.plist` usage strings |

---

## Documentation

| Document | Language | Description |
|----------|----------|-------------|
| [README.ja.md](README.ja.md) | Japanese | This readme in Japanese |
| [簡易仕様書_QuickDine.txt](簡易仕様書_QuickDine.txt) | Japanese | Full assignment-style spec and design notes |
| [agents/INDEX.md](agents/INDEX.md) | English | Agent / contributor guide |

---

## Author

**Vrowdice**

---

## License

Private / assignment project — not published to pub.dev (`publish_to: 'none'`).
