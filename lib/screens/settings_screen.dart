import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/favorites_service.dart';
import '../services/quick_pin_service.dart';
import '../services/settings_service.dart';
import '../utils/confirm_dialog.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/screen_with_credit.dart';
import '../widgets/search_count_dropdown.dart';
import '../widgets/search_radius_dropdown.dart';

/// 앱 설정 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _clearFavorites(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showConfirmDialog(
      context,
      title: l10n.confirmClearFavorites,
      message: l10n.confirmClearFavoritesMessage,
    );
    if (!ok || !context.mounted) return;

    await FavoritesService.instance.clearAll();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.favoritesCleared)),
    );
  }

  Future<void> _clearQuickPins(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showConfirmDialog(
      context,
      title: l10n.confirmClearQuickPins,
      message: l10n.confirmClearQuickPinsMessage,
    );
    if (!ok || !context.mounted) return;

    await QuickPinService.instance.clearAll();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.quickPinsCleared)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const sectionTitleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ScreenWithCredit(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.sectionSearch, style: sectionTitleStyle),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: SettingsService.instance,
              builder: (context, _) {
                return SearchRadiusDropdown(
                  value: SettingsService.instance.defaultSearchRadius,
                  decoration: InputDecoration(
                    labelText: l10n.defaultSearchRadius,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  onChanged: SettingsService.instance.setDefaultSearchRadius,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              l10n.defaultSearchRadiusHint,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: SettingsService.instance,
              builder: (context, _) {
                return SearchCountDropdown(
                  value: SettingsService.instance.defaultMaxSearchCount,
                  decoration: InputDecoration(
                    labelText: l10n.defaultMaxSearchCount,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  onChanged: SettingsService.instance.setDefaultMaxSearchCount,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              l10n.defaultMaxSearchCountHint,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(l10n.sectionLanguage, style: sectionTitleStyle),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: SettingsService.instance,
              builder: (context, _) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.language,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: SettingsService.instance.localeCode,
                      items: SettingsService.supportedLanguageCodes
                          .map(
                            (code) => DropdownMenuItem(
                              value: code,
                              child: Text(languageLabel(l10n, code)),
                            ),
                          )
                          .toList(),
                      onChanged: (code) {
                        if (code != null) {
                          SettingsService.instance.setLocaleCode(code);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.sectionData, style: sectionTitleStyle),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.favorite_border),
              title: Text(l10n.clearAllFavorites),
              subtitle: Text(l10n.clearAllFavoritesSubtitle),
              onTap: () => _clearFavorites(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.push_pin_outlined),
              title: Text(l10n.clearAllQuickPins),
              subtitle: Text(l10n.clearAllQuickPinsSubtitle),
              onTap: () => _clearQuickPins(context),
            ),
            const SizedBox(height: 24),
            Text(l10n.sectionAppInfo, style: sectionTitleStyle),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.restaurant),
              title: Text(l10n.appTitle),
              subtitle: Text(l10n.appDescription),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.dataProvider),
              subtitle: Text(l10n.dataProviderValue),
            ),
          ],
        ),
      ),
    );
  }
}
