# Maps & Location

## Components

| File | Role |
|------|------|
| `screens/search_screen.dart` | Layout orchestration, sheet extent, pill position |
| `widgets/search_map_stack.dart` | Map overlays: Quick Pin, my-location, bouncy pin button |
| `widgets/map_location_picker.dart` | Google Map, circle, markers, padding, camera |
| `widgets/search_floating_controls.dart` | Top floating radius/count card |
| `widgets/search_pill_button.dart` | Bottom-center search CTA |
| `widgets/search_results_sheet.dart` | DraggableScrollableSheet list |
| `widgets/quick_pin_panel.dart` | Slide-in pin manager |
| `constants/search_radius.dart` | Range 1~5 → meters |
| `services/location_service.dart` | GPS + `LocationException` |

## Google Maps API key

Single source: `assets/env` → `GOOGLE_MAPS_API_KEY`

| Platform | Mechanism |
|----------|-----------|
| Flutter | `flutter_dotenv` + `MapsKeyService.initialize()` |
| Android | `build.gradle.kts` → `manifestPlaceholders` → Manifest |
| iOS | MethodChannel `quick_dine/maps_key` → `AppDelegate` |

## Map markers & circle

| Overlay | Style | Notes |
|---------|-------|-------|
| Search center | Blue marker | Moves on tap / GPS / show-on-map |
| Search radius | Primary-tinted `Circle` | Radius from `searchRadiusMeters(range)` |
| Quick Pin | Colored by index | Tap → move search center |
| Shop | Orange marker | Tap → `DetailScreen` |

## Map padding & camera

- `GoogleMap.padding`: `top` = floating controls height; `bottom` = sheet extent × **body height** when sheet visible
- **Body height** = `LayoutBuilder.constraints.maxHeight` (not full screen — AppBar excluded)
- `fitToSearchResults()`: bounds edge padding ~48px only; **do not** add `bottomPadding` again to `newLatLngBounds` (causes "View size too small after padding")
- On failure: fallback `newLatLngZoom` on search center

## SearchScreen overlay positions

| Control | Position |
|---------|----------|
| Floating filters | Top of body (`SearchFloatingControls`) |
| Quick Pin + My location | Below filters; left/right aligned to `horizontalMargin` (12px) |
| Search pill | Bottom-center; `bottom = sheetExtent × stackHeight + verticalMargin` |
| Native zoom (+/-) | Bottom-right; no extra Flutter overlay on zoom area |

Quick Pin button uses `_BouncyMapOverlayButton` (scale 0.92 on press, elastic release).

## Bottom sheet (`SearchResultsSheet`)

- `initialChildSize: 0.3`, `maxChildSize: 0.8`, `minChildSize: 0`
- Snap: 0, 0.3, 0.8
- Header: centered drag handle (Stack), close (X) right — `animateTo(0)` then `onDismissed`
- Swipe to 0 also dismisses
- `onExtentChanged` → parent updates `_sheetExtent` for pill + map padding sync

## Quick Pins

- Open: Quick Pin button (top-left below filters)
- Add / select / delete / clear-all via panel + Settings
- `moveTo()` on map/Quick Pin clears `_searchResults` in SearchScreen

## GPS

- Startup: silent `_applyCurrentLocation`
- Manual: my-location button (same Y as Quick Pin)
- Errors: `locationErrorMessage()` in `l10n_helpers.dart`

## Show on map

`DetailScreen` / `FavoritesScreen` → pop `Shop` → `_showShopOnMap`:
- Update search center coords
- Preserve/add shop in results
- Avoid `moveTo()` to keep results

## HotPepper constraint

API accepts **Japanese coordinates** only. Default center: Tokyo Station.
