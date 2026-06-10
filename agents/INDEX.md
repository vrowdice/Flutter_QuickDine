# QuickDine Agent Index

Documents agents should read before changing code or configuration.

## Quick links

| Topic | Doc |
|-------|-----|
| App structure, screen flow, coding rules | [reference/architecture.md](reference/architecture.md) |
| HotPepper API, model, credits, favorites | [reference/api.md](reference/api.md) |
| Google Maps, GPS, Quick Pins | [reference/maps.md](reference/maps.md) |
| Localization (ko / ja / en) | [reference/localization.md](reference/localization.md) |
| Local dev, env, build | [setup/dev-environment.md](setup/dev-environment.md) |

## Source tree (tracked)

```
lib/
  main.dart                    # dotenv → MapsKeyService → local services → QuickDineApp
  app.dart                     # MaterialApp, theme, locale, l10n delegates
  constants/
    api_constants.dart         # URLs, env names, default Tokyo coords, maxResultCount
    search_count.dart          # max result options [10,20,30,50,100], default 20
    search_radius.dart         # HotPepper range 1~5 (300m~3000m)
    quick_pin_colors.dart      # Pin list/marker colors
  models/
    shop.dart                  # HotPepper JSON + lat/lng + favorites serialization
    quick_pin.dart             # Saved map location
  services/
    hotpepper_api.dart
    location_service.dart      # GPS + LocationException codes
    favorites_service.dart     # shared_preferences
    quick_pin_service.dart
    settings_service.dart      # default max count, default radius, locale
    maps_key_service.dart      # iOS MethodChannel key injection
  screens/
    search_screen.dart         # map hub: AppBar, floating filters, pill search, bottom sheet
    detail_screen.dart         # photo, address, hours, access, show-on-map, favorite
    favorites_screen.dart
    settings_screen.dart       # default radius, max count, language, clear data
  widgets/
    map_location_picker.dart   # Google Map, radius circle, search/shop/quick-pin markers
    search_map_stack.dart      # map + quick pin overlay + my-location (bounce on quick pin)
    search_floating_controls.dart  # top floating card: radius + max count
    search_pill_button.dart    # bottom-center pill CTA search button
    search_results_sheet.dart  # DraggableScrollableSheet result list
    search_count_dropdown.dart
    search_radius_dropdown.dart
    quick_pin_panel.dart
    shop_list_tile.dart        # list row: name, access, thumbnail
    favorite_icon_button.dart
    detail_row.dart            # DetailSection (comma/、/slash split)
    screen_with_credit.dart
    hot_pepper_credit_bar.dart
    hot_pepper_image_credit.dart
  l10n/
    app_en.arb, app_ko.arb, app_ja.arb
    app_localizations.dart     # generated — do not edit by hand
  utils/
    l10n_helpers.dart
    confirm_dialog.dart
assets/
  env                          # gitignored — API keys (local only)
  env.example                  # template for setup
android/app/
  build.gradle.kts             # reads assets/env → manifestPlaceholders
  src/main/AndroidManifest.xml # ${GOOGLE_MAPS_API_KEY} placeholder
ios/Runner/
  AppDelegate.swift            # MethodChannel quick_dine/maps_key
l10n.yaml                      # flutter gen-l10n config
```

## Task routing

| User intent | Read first | Typical touch points |
|-------------|------------|----------------------|
| Search, radius, max count, API | architecture, api | `search_screen.dart`, `hotpepper_api.dart`, `search_radius.dart`, `search_count.dart`, `settings_service.dart` |
| Bottom sheet / result list | architecture, maps | `search_results_sheet.dart`, `shop_list_tile.dart`, `search_screen.dart` |
| Search pill / floating filters | architecture | `search_pill_button.dart`, `search_floating_controls.dart` |
| Map markers, radius circle, show-on-map | maps, architecture | `map_location_picker.dart`, `search_map_stack.dart` |
| Detail UI / access parsing | architecture, api | `detail_screen.dart`, `detail_row.dart` |
| Map, GPS, Quick Pins | maps | `quick_pin_panel.dart`, `search_map_stack.dart`, `quick_pin_service.dart` |
| Favorites | architecture, api | `favorites_service.dart`, `favorites_screen.dart`, `shop.dart` |
| Settings, language | architecture, localization | `settings_screen.dart`, `settings_service.dart`, `app.dart`, `app_*.arb` |
| API keys, env, build | setup, maps | `assets/env`, `build.gradle.kts`, `AppDelegate.swift` |
| Add UI string / translate | localization | `app_en.arb`, `app_ko.arb`, `app_ja.arb` |
| Add Shop fields | api, architecture | `shop.dart`, `hotpepper_api.dart`, list/detail UI, favorites `toJson` |

## Out of scope (unless asked)

- `build/`, `.dart_tool/`, `lib/l10n/app_localizations_*.dart` (generated) — do not hand-edit generated l10n output
- Platform boilerplate (`windows/`, `linux/`, `macos/`, `web/`) — minimize unrelated changes
