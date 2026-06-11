# Maps & Location

## Components

| File | Role |
|------|------|
| `search_screen.dart` | Layout, sheet extent, genre/radius state |
| `search_map_stack.dart` | Quick Pin, my-location, bouncy pin button |
| `map_location_picker.dart` | Map, circle, markers, padding, `fitToSearchResults` |
| `search_floating_controls.dart` | **Unified search panel** (dropdowns + genre chips) |
| `search_pill_button.dart` | Bottom search CTA |
| `search_results_sheet.dart` | Draggable result list |
| `quick_pin_panel.dart` | Pin manager overlay |

## Search panel inset

`SearchFloatingControls.estimatedHeight` includes dropdown row + genre chip row. Pass as `topOverlayInset` to map and `MapLocationPicker.topPadding`.

Genre chips: horizontal scroll, 16px end padding, 8px spacing, selected = primary fill.

## Markers & circle

| Overlay | Style |
|---------|-------|
| Search center | Blue marker |
| Radius | Primary-tinted `Circle` from `searchRadiusMeters(range)` |
| Quick Pin | Colored by index |
| Shop | Orange marker → `DetailScreen` |

## Padding & camera

- `GoogleMap.padding`: top = panel height; bottom = sheet extent × **body height**
- `fitToSearchResults()`: ~48px bounds padding only — do not double-apply bottom padding in `newLatLngBounds`

## Quick Pins & GPS

- `moveTo()` / map tap / GPS clears `_searchResults` via `onLocationChanged`
- Show-on-map from detail: update coords only, keep results

## Japan-only

HotPepper accepts Japanese coordinates. Default: Tokyo Station.
