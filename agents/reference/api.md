# HotPepper API

## Overview

- **Base URL:** `https://webservice.recruit.co.jp/hotpepper/gourmet/v1/`
- **Implementation:** `lib/services/hotpepper_api.dart`
- **Reference:** https://webservice.recruit.co.jp/doc/hotpepper/reference.html
- **HTTP timeout:** 15 seconds (`http.get(uri).timeout(...)`)

## Search parameters (implemented)

| Param | Value | UI |
|-------|-------|-----|
| `lat`, `lng` | Map search center | Default Tokyo Station |
| `range` | 1~5 | `SearchRadiusDropdown` |
| `count` | 10 / 20 / 30 / 50 / 100 | `SearchCountDropdown` |
| `genre` | G001, G004, … (optional) | Genre chips in `SearchFloatingControls` |
| `parking` | `1` when enabled | `FilterChip` — parking |
| `private_room` | `1` when enabled | `FilterChip` — private room |

Parking / private-room toggles clear cached results; user must re-search.

### Genre codes (`search_genre.dart`)

| Code | Filter |
|------|--------|
| *(omit)* | All |
| G001 | Izakaya |
| G004 | Japanese |
| G006 | Italian/French |
| G007 | Chinese |
| G008 | Yakiniku |
| G009 | Asian/Ethnic |
| G014 | Cafe/Dessert |

Labels via `genreLabel()` in `l10n_helpers.dart`.

### Range codes

| `range` | Radius |
|---------|--------|
| 1 | 300m |
| 2 | 500m (default) |
| 3 | 1000m |
| 4 | 2000m |
| 5 | 3000m |

No pagination — first page only. `count` caps load at wide radius.

**Search deduplication:** `SearchScreen` increments `_searchRequestId` per request; stale responses are ignored after `await`.

## NOT supported — do not implement

| Feature | Reason |
|---------|--------|
| **Open now / 営業中** | No API param for current-time open status. Response `open` is display text only. `midnight=1` means “open after 23:00”, not “open now”. **Do not parse `open` text.** |

### Alternative API filters (available, not yet in UI)

`wifi`, `card`, `non_smoking`, `midnight`, etc. — all `0`/`1` query params per official reference.

## Shop model (`lib/models/shop.dart`)

| Field | API source | UI |
|-------|------------|-----|
| `id`, `name`, `access`, `logoImage` | standard | list |
| `address`, `open`, `photoUrl`, `lat`, `lng` | standard | detail, map |
| `phone` | `phone` | `ShopDetailActions` → `tel:` |
| `shopUrl` | `urls.smart_phone` → `mobile` → `pc` | external browser |
| `budget` | `budget.name` → `budget.average` | `DetailSection` |
| `genreName` | `genre.name` | list tile + subtitle `[genre]` |
| `catchPhrase` | `catch` | subtitle with genre |

- `shopSubtitle` — `[genreName] catchPhrase` formatting
- `hasPhone`, `hasShopUrl`, `hasBudget`, `hasSubtitle`
- `toJson` / `fromJson` for favorites (older saves missing new fields → empty defaults)

## Detail actions

- `url_launcher_helpers.dart` — `launchPhoneCall`, `launchExternalWebUrl`
- Android manifest includes `tel:` query for package visibility
- Buttons hidden when phone/URL absent (common in search API responses)

## Credit compliance

- `HotPepperCreditBar` + `HotPepperImageCredit` — Japanese text, all locales
- Never mix with Vrowdice branding

## Env

| Variable | Purpose |
|----------|---------|
| `HOTPEPPER_API_KEY` | API auth |
| `GOOGLE_MAPS_API_KEY` | Maps SDK |

Template: `assets/env.example`. Real keys: `assets/env` (gitignored).
