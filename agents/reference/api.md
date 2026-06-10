# HotPepper API

## Overview

- **Base URL:** `https://webservice.recruit.co.jp/hotpepper/gourmet/v1/`
- **Implementation:** `lib/services/hotpepper_api.dart`
- **Auth:** query `key` = `HOTPEPPER_API_KEY` (`assets/env`)
- **Search params:** `lat`, `lng`, `range`, `format=json`, `count`

## Search parameters

| Param | Value | Notes |
|-------|-------|-------|
| `lat`, `lng` | User-selected map point | Typically Japan; default Tokyo Station |
| `range` | 1~5 (user picks) | `SearchRadiusDropdown`; clamped via `clampSearchRadius()` |
| `count` | 10 / 20 / 30 / 50 / 100 | `SearchCountDropdown`; caps API + map + list load |

### Range codes

| `range` | Radius |
|---------|--------|
| 1 | 300m |
| 2 | 500m (default) |
| 3 | 1000m |
| 4 | 2000m |
| 5 | 3000m |

At 3000m, **`count` limits** fetched/rendered shops (Fenrir load defense). No pagination — first page only.

Defaults from `SettingsService`: `search_range`, `search_max_count`.

## Shop model (`lib/models/shop.dart`)

| Field | API source | Notes |
|-------|------------|-------|
| `id` | `id` | Dedup; fallback `name\|address` |
| `name` | `name` | |
| `access` | `access` | List + detail; split on `,` `、` `/` `／` in detail |
| `logoImage` | `logo_image` | Thumbnail in `ShopListTile` |
| `address` | `address` | |
| `open` | `open` | Hours |
| `photoUrl` | `photo.pc.l` → `m` → `s` | Detail hero image |
| `lat`, `lng` | `lat`, `lng` | Map marker, radius context, show-on-map |

- `hasLocation`, `favoriteKey`, `toJson` / `fromJson` for favorites

## Search results display

1. **Map** — orange markers (`MapLocationPicker`); tap → `DetailScreen`
2. **Bottom sheet** — `SearchResultsSheet` + `ShopListTile` (name, access, thumbnail); tap → `DetailScreen`
3. **Search center** — blue marker + **radius circle** (`searchRadiusRange`)

After search: `fitToSearchResults()` fits camera (use small bounds padding only — `GoogleMap.padding` already accounts for overlays; do not double-count in `newLatLngBounds`).

## Favorites (`FavoritesService`)

- Key: `favorite_shops`
- UI: `FavoriteIconButton` on detail; `FavoritesScreen` from Search AppBar

## Credit compliance (mandatory)

- `HotPepperCreditBar` — Japanese link text; never hide or shrink
- `HotPepperImageCredit` — near API images; stays Japanese in all locales
- Search: bar at bottom when no sheet; footer inside sheet list when sheet open
- Detail / Favorites / Settings: `ScreenWithCredit`

## Env keys (`ApiConstants`)

| Constant | Env variable |
|----------|--------------|
| `envApiKeyName` | `HOTPEPPER_API_KEY` |
| `envGoogleMapsApiKeyName` | `GOOGLE_MAPS_API_KEY` |

`assets/env` is gitignored. Template: `assets/env.example`.
