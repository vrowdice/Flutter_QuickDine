# Localization

## Overview

**Korean (ko)**, **Japanese (ja)**, **English (en)** — `lib/l10n/app_*.arb` → `flutter gen-l10n`.

## Wiring

- `app.dart` — delegates, `SettingsService.instance.locale`, `debugShowCheckedModeBanner: false`
- `l10n_helpers.dart` — `locationErrorMessage`, `languageLabel`, `genreLabel`

## Do NOT localize

- HotPepper credit / image attribution (Japanese mandatory)
- API-sourced shop text (`genre.name`, `catch`, `open`, etc.) — displayed as returned

## Key groups

| Keys | Used in |
|------|---------|
| `searchRadius`, `searchPill`, `searchMaxCount` | Search panel |
| `genreAll`, `genreIzakaya`, … `genreCafe` | Genre chips (`genreLabel`) |
| `showOnMap`, `shopLocationUnavailable`, `showedShopOnMap` | Map return flow |
| `detailCall`, `detailWeb`, `averageBudget` | Detail actions & budget |
| `launchPhoneFailed`, `launchWebFailed` | url_launcher errors |
| `developedBy` | `StudioCredit` (Settings) |
| `defaultSearchRadius`, settings / data / language keys | Settings |

## Adding strings

1. `app_en.arb` (template)
2. `app_ko.arb`, `app_ja.arb`
3. `flutter pub get`
