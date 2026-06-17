# AGENTS.md

---

## Harness Protocol (Universal)

Cross-project rules. Reuse this section in other repos; replace everything below `---` with project-specific content.

DO NOT:
- **Irreversible or project-wide destruction** unless the user explicitly requests it: git history wipe, force-push (especially `main`/`master`), repo-wide reset/hard reset, mass file or directory delete, production deploy, database drop/truncate/migrate on prod, shell cleanup equivalent to `rm -rf`.
- **Git actions without explicit request:** commit, push, amend, rebase, change git config, skip hooks (`--no-verify`, `--no-gpg-sign`), interactive git (`-i` flags).
- **Secrets exposure:** commit, log, or paste credentials — `assets/env`, API keys, tokens, passwords, private certs.
- **Scope creep:** unrelated refactors, drive-by fixes, unrequested docs/files/dependencies, or deleting/rewriting files not required for the requested task.
- **Guessing:** proceed when intent, scope, or blast radius is unclear — ask clarifying questions until confident.

ALWAYS:
- Before using MCP: confirm which servers and tools are enabled in this session; read each tool's schema/descriptor before calling — do not assume tools from other projects or prior sessions exist.
- Read project-specific content below `---` and surrounding code before editing.
- Minimize diff scope; match existing conventions; prefer the simplest correct fix.
- Verify when possible (`flutter analyze`, build/run); do not claim success without checking.
- If a command or approach fails — diagnose, retry an alternative, or ask; do not stop after one attempt.
- Confirm before breaking public APIs, schemas, or shared interfaces.

---

## QuickDine

Flutter app that searches restaurants in **Japan** via the HotPepper Gourmet API. Full-screen **Google Maps** hub with radius/count/**genre** filters, **parking / private-room** filter chips, bottom-sheet results (incl. **random pick**), shop **detail** (call, web, budget), **Quick Pins**, and **favorites**. UI: **ko / ja / en**. Studio splash: **Vrowdice** logo.

**Package ID:** `com.vrowdice.quick_dine`

**Start:** [agents/INDEX.md](agents/INDEX.md)

### When changing code

1. [agents/reference/architecture.md](agents/reference/architecture.md) — flow, search panel, sheet `ValueNotifier`, splash, theme
2. [agents/reference/api.md](agents/reference/api.md) — HotPepper params, `Shop` fields, credits; **no open-now filter**
3. [agents/reference/maps.md](agents/reference/maps.md) — map padding, markers, `SearchOverlayMetrics`
4. [agents/reference/localization.md](agents/reference/localization.md)
5. [agents/setup/dev-environment.md](agents/setup/dev-environment.md)

### Layer map (`lib/`)

| Layer | Path | Role |
|-------|------|------|
| Entry | `main.dart`, `app.dart` | `runApp`; `MaterialApp` + theme |
| Bootstrap | `services/app_bootstrap.dart`, `screens/splash_screen.dart` | Init + splash → `SearchScreen` |
| Theme | `theme/app_theme.dart` | `AppColors`, Noto fonts, primary AppBar |
| Screens | `screens/` | Splash, Search (map hub), Detail, Favorites, Settings |
| Widgets | `widgets/` | Search panel, map, credits, `ShopDetailActions`, `StudioCredit` |
| Services | `services/` | HotPepper API (`genre`, `parking`, `private_room`), GPS, prefs, Maps key |
| Models | `models/` | `Shop` (phone, url, budget, genre, catch), `QuickPin` |
| Constants | `constants/` | API, radius, count, **genre codes**, `app_assets` |
| Utils | `utils/` | l10n helpers, `url_launcher_helpers`, `navigation_helpers`, `search_overlay_metrics`, `confirm_dialog` |
| l10n | `l10n/` | `app_*.arb` |

### Hard constraints

- **Japan-only coordinates** for HotPepper; default Tokyo Station.
- **HotPepper credits** mandatory on API screens; Japanese credit copy in all locales.
- **No open-now filter** — API unsupported; use `parking` / `private_room` etc. if adding filters.
- **Secrets:** `assets/env` gitignored; template `assets/env.example`.
- **UI strings** in ARB only (except API-returned shop text).
- **Vrowdice branding** only in splash + Settings `StudioCredit` — not on HotPepper credit UI.
- **Sheet drag:** update `_sheetExtentNotifier`, not full-screen `setState`.

### Verify changes

```powershell
flutter pub get
flutter analyze lib
flutter run
```

On PowerShell, chain commands with `;` (not `&&`).
