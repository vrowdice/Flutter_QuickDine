# Maps & Location

## Components

| File | Role |
|------|------|
| `search_screen.dart` | Layout, `_sheetExtentNotifier`, filter/radius state, `_buildMapAndSearchPill` |
| `search_overlay_metrics.dart` | Sheet extent → map/panel/pill insets |
| `search_map_stack.dart` | Quick Pin, my-location, bouncy pin button |
| `map_location_picker.dart` | Map, circle, markers, padding, `fitToSearchResults`, overlay cache |
| `search_floating_controls.dart` | **Unified search panel** (dropdowns + filter chips + genre chips) |
| `search_pill_button.dart` | Bottom search CTA |
| `search_results_sheet.dart` | Draggable result list + random pick + close |
| `quick_pin_panel.dart` | Pin manager overlay (`_QuickPinListItem`) |

## Search panel inset

`SearchFloatingControls.estimatedHeight` includes dropdown row + chip row. Pass as `topOverlayInset` to map and `MapLocationPicker.topPadding`.

**Filter chips:** parking, private room — `FilterChip`, secondary color, checkmark.  
**Genre chips:** horizontal scroll, divider between filter and genre groups, selected = primary fill.

## Sheet extent & padding

- `_sheetExtentNotifier` (`ValueNotifier<double>`) — **not** `setState` on drag
- `SearchOverlayMetrics.from(sheetVisible, sheetExtent, stackHeight)`:
  - `mapBottomPadding` — `GoogleMap.padding` bottom
  - `panelBottomInset` — Quick Pin panel bottom
  - `searchPillBottom` — `SearchPillButton` position
- `creditBarInset` = 44 when sheet hidden

Single `ValueListenableBuilder` wraps map stack + search pill (both use same metrics).

## Markers & circle

| Overlay | Style |
|---------|-------|
| Search center | Blue marker |
| Radius | Primary-tinted `Circle` from `searchRadiusMeters(range)` |
| Quick Pin | Colored by index |
| Shop | Orange marker → `DetailScreen` |

**Caching (`MapLocationPicker`):** `_markers` / `_circles` rebuilt only when `shops`, `quickPins`, `searchRadiusRange`, or `_selectedPosition` change — not when `bottomPadding` alone changes. Dispose `GoogleMapController` in `dispose()`.

## Padding & camera

- `GoogleMap.padding`: top = panel height; bottom = `SearchOverlayMetrics.mapBottomPadding`
- `fitToSearchResults()`: ~48px bounds padding only — do not double-apply bottom padding in `newLatLngBounds`

## Quick Pins & GPS

- `moveTo()` / map tap / GPS clears `_searchResults` via `onLocationChanged`
- Show-on-map from detail: update coords only, keep results

## Random pick (results sheet)

Left header button (`randomPick` l10n) picks a random shop from current results and opens detail via `onShopTap`.

## Japan-only

HotPepper accepts Japanese coordinates. Default: Tokyo Station.
