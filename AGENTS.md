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

Flutter app that searches nearby restaurants in **Japan** via the HotPepper Gourmet API. Users pick a search origin on Google Maps, save **Quick Pins** for frequent locations, browse list/detail screens, and manage **favorites** locally. UI supports **Korean, Japanese, and English** (changeable in Settings).

**Package ID:** `com.vrowdice.quick_dine`

**Start:** [agents/INDEX.md](agents/INDEX.md)

### When changing code

1. **Architecture & screen flow:** [agents/reference/architecture.md](agents/reference/architecture.md)
2. **HotPepper API & credit compliance:** [agents/reference/api.md](agents/reference/api.md) — credit attribution is mandatory on API data/image screens
3. **Google Maps & location:** [agents/reference/maps.md](agents/reference/maps.md) — Maps key single source: `assets/env`
4. **Localization (ko / ja / en):** [agents/reference/localization.md](agents/reference/localization.md)
5. **Environment & run:** [agents/setup/dev-environment.md](agents/setup/dev-environment.md)

### Layer map (`lib/`)

| Layer | Path | Role |
|-------|------|------|
| Entry | `main.dart`, `app.dart` | Load env, init services, `MaterialApp` + locale |
| Screens | `screens/` | Search → List → Detail; Favorites; Settings |
| Widgets | `widgets/` | Map, Quick Pin panel, credits, favorites, detail UI |
| Services | `services/` | HotPepper API, GPS, favorites, quick pins, settings, Maps key |
| Models | `models/` | `Shop`, `QuickPin` |
| Constants | `constants/` | API URLs, env key names, default coords, pin colors |
| l10n | `l10n/` | `app_*.arb` → generated `AppLocalizations` |
| Utils | `utils/` | l10n helpers (location errors, language labels) |

### Hard constraints

- **Japan-only data:** HotPepper only accepts Japanese coordinates. Default map center is Tokyo Station; users outside Japan rely on map tap or saved Quick Pins.
- **Credit requirement:** Screens showing API data or images must keep `ScreenWithCredit` and `HotPepperImageCredit`. Official HotPepper credit copy stays **Japanese in all locales**.
- **Secrets:** `assets/env` is `.gitignore`d. Template: `assets/env.example`. Never put real key values in commits, logs, or docs.
- **UI strings:** User-facing copy goes in `lib/l10n/app_*.arb` — not hardcoded in widgets. Use `AppLocalizations.of(context)!`.
- **Local data:** Favorites and Quick Pins use `shared_preferences`; Settings stores default radius and locale.

### Verify changes

```powershell
flutter pub get
flutter analyze lib
flutter run
```

On PowerShell, chain commands with `;` (not `&&`).
