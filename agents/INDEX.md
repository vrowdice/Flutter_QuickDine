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
  main.dart                    # WidgetsFlutterBinding → runApp(QuickDineApp)
  app.dart                     # MaterialApp, theme, locale; home: SplashScreen
  theme/
    app_theme.dart             # AppColors, primary/secondary, Noto fonts, AppBar primary
  constants/
    api_constants.dart
    app_assets.dart            # app_icon, Vrowdice logos
    search_count.dart
    search_radius.dart
    search_genre.dart          # genre codes G001~G014
    quick_pin_colors.dart
  models/
    shop.dart                  # full HotPepper fields + favorites JSON
    quick_pin.dart
  services/
    app_bootstrap.dart         # env + services init (called from SplashScreen)
    hotpepper_api.dart         # lat/lng/range/count/genre/parking/private_room search
    location_service.dart
    favorites_service.dart
    quick_pin_service.dart
    settings_service.dart
    maps_key_service.dart
  screens/
    splash_screen.dart         # Vrowdice logo splash → SearchScreen
    search_screen.dart         # map hub (sheet extent via ValueNotifier)
    detail_screen.dart         # photo, subtitle, actions, info cards
    favorites_screen.dart
    settings_screen.dart       # app info + StudioCredit footer
  widgets/
    search_floating_controls.dart  # unified panel: dropdowns + filter chips + genre chips
    search_map_stack.dart
    map_location_picker.dart       # marker/circle cache, controller dispose
    search_pill_button.dart
    search_results_sheet.dart      # draggable list + random-pick + close
    shop_list_tile.dart
    shop_detail_actions.dart       # call + web OutlinedButtons
    app_logo.dart                  # QuickDine app icon in UI
    studio_credit.dart             # Developed by Vrowdice (Settings)
    detail_row.dart
    quick_pin_panel.dart
    search_count_dropdown.dart
    search_radius_dropdown.dart
    favorite_icon_button.dart      # optional isFavorite (list-level listener)
    screen_with_credit.dart
    hot_pepper_credit_bar.dart
    hot_pepper_image_credit.dart
  utils/
    l10n_helpers.dart              # locationError, languageLabel, genreLabel
    url_launcher_helpers.dart        # tel: + external browser
    confirm_dialog.dart              # showConfirmDialog, clearWithConfirm
    navigation_helpers.dart          # pushShopDetail
    search_overlay_metrics.dart      # sheet extent → map/pill insets
  l10n/
    app_en.arb, app_ko.arb, app_ja.arb
assets/
  env                          # gitignored
  env.example
  images/
    app_icon.png               # launcher + in-app QuickDine logo
    VrowdiceLogoSimpleBlack.png
    VrowdiceLogoSimpleWhite.png
android/app/src/main/res/
  mipmap-*/ic_launcher.png     # from lib/AppIcons (source)
  drawable/splash_logo.png     # native launch splash (white logo)
  values/colors.xml            # splash_primary
ios/Runner/Assets.xcassets/AppIcon.appiconset/
l10n.yaml
```

## Task routing

| User intent | Read first | Typical touch points |
|-------------|------------|----------------------|
| Search, radius, count, genre, filters, API | architecture, api | `search_screen.dart`, `hotpepper_api.dart`, `search_floating_controls.dart`, `search_genre.dart` |
| Bottom sheet / result list / random pick | architecture, maps | `search_results_sheet.dart`, `shop_list_tile.dart` |
| Sheet extent / map padding | architecture, maps | `search_overlay_metrics.dart`, `_sheetExtentNotifier` in `search_screen.dart` |
| Detail actions / Shop fields | api, architecture | `shop.dart`, `detail_screen.dart`, `shop_detail_actions.dart` |
| Navigation to detail | architecture | `navigation_helpers.dart` (`pushShopDetail`) |
| Theme / colors | architecture | `app_theme.dart` |
| Splash / bootstrap / studio branding | architecture | `splash_screen.dart`, `app_bootstrap.dart`, `studio_credit.dart` |
| Map, GPS, Quick Pins | maps | `search_map_stack.dart`, `map_location_picker.dart` |
| Favorites | api | `favorites_service.dart`, `favorite_icon_button.dart`, `shop.dart` `toJson` |
| Settings, language, data clear | localization | `settings_screen.dart`, `settings_service.dart`, `clearWithConfirm` |
| Add UI string | localization | `app_*.arb` |
| API keys, build | setup | `assets/env`, Android/iOS native config |

## Out of scope (unless asked)

- `lib/AppIcons/` — icon source pack; deployed copies live under `android/`, `ios/`, `assets/images/`
- `build/`, `.dart_tool/`, generated `app_localizations_*.dart`
- **Open-now filter** — HotPepper API does not support; do not parse `open` text (see [api.md](reference/api.md))
