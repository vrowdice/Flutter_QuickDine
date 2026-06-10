# Localization

## Overview

QuickDine supports **Korean (ko)**, **Japanese (ja)**, and **English (en)**.

- **Config:** `l10n.yaml` at project root
- **Source strings:** `lib/l10n/app_en.arb` (template), `app_ko.arb`, `app_ja.arb`
- **Generated:** `lib/l10n/app_localizations.dart` (+ per-locale files) — **do not edit by hand**
- **Regenerate:** `flutter pub get` (with `flutter: generate: true` in `pubspec.yaml`)

## Runtime wiring

| File | Role |
|------|------|
| `app.dart` | `localizationsDelegates`, `supportedLocales`, `locale: SettingsService.instance.locale` |
| `settings_service.dart` | Persists `app_locale` (`ko` / `ja` / `en`; absent = system default) |
| `settings_screen.dart` | Language dropdown: System / Korean / 日本語 / English |
| `utils/l10n_helpers.dart` | `locationErrorMessage`, `languageLabel` |

`SettingsService` extends `ChangeNotifier`. `QuickDineApp` wraps `MaterialApp` in `ListenableBuilder` so language changes apply immediately.

## Usage in widgets

```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.searchTitle);
Text(l10n.searchCoords(lat, lng));  // placeholders
```

Never hardcode user-facing UI strings in `screens/` or `widgets/`.

## What NOT to localize

HotPepper **credit compliance** strings stay Japanese in all locales:

- `HotPepperCreditBar` — `Powered by ホットペッパーグルメ Webサービス`
- `HotPepperImageCredit` — `【画像提供：ホットペッパー グルメ】`
- `dataProviderValue` in ARB may reference `ホットペッパーグルメ Webサービス` (provider name)

Service-layer exceptions (e.g. missing env key, HTTP errors) may remain Korean/technical — UI should prefix with l10n `errorPrefix` / `locationErrorPrefix` where shown.

## Adding a new string

1. Add key + English value to `app_en.arb`
2. Add translations to `app_ko.arb` and `app_ja.arb`
3. Run `flutter pub get` to regenerate
4. Use `l10n.yourKey` in Dart

For parameterized strings, use ARB placeholders:

```json
"searchCoords": "Search coords: {lat}, {lng}",
"@searchCoords": {
  "placeholders": {
    "lat": {"type": "String"},
    "lng": {"type": "String"}
  }
}
```

## Language names in picker

`languageLabel(l10n, code)` returns localized labels for `system`, `ko`, `ja`, `en`. Language names in the picker are shown in the **current UI language** (e.g. Korean UI shows "日本語" for Japanese option).

## Search / map UI keys (recent)

| Key | Used in |
|-----|---------|
| `searchRadius`, `searchRadiusMeters` | `SearchRadiusDropdown`, floating controls, Settings |
| `searchPill` | `SearchPillButton` bottom CTA |
| `defaultSearchRadius`, `defaultSearchRadiusHint` | Settings default radius |
| `showOnMap`, `shopLocationUnavailable`, `showedShopOnMap` | Detail / Favorites show-on-map flow |

## Shop model fallbacks

`Shop.fromJson` missing-field fallbacks (`'이름 없음'`, etc.) are API edge-case defaults, not primary UI copy. Localize in UI only if these values are displayed often enough to matter.
