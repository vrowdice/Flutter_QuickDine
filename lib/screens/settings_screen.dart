import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/favorites_service.dart';
import '../services/quick_pin_service.dart';
import '../services/settings_service.dart';
import '../utils/confirm_dialog.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/app_logo.dart';
import '../widgets/screen_with_credit.dart';
import '../widgets/studio_credit.dart';
import '../widgets/search_count_dropdown.dart';
import '../widgets/search_radius_dropdown.dart';

InputDecoration _settingsFieldDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  );
}

TextStyle _hintTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: 12,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}

/// 앱 설정 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const sectionTitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
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
                final settings = SettingsService.instance;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SearchRadiusDropdown(
                      value: settings.defaultSearchRadius,
                      decoration: _settingsFieldDecoration(
                        l10n.defaultSearchRadius,
                      ),
                      onChanged: settings.setDefaultSearchRadius,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.defaultSearchRadiusHint,
                      style: _hintTextStyle(context),
                    ),
                    const SizedBox(height: 16),
                    SearchCountDropdown(
                      value: settings.defaultMaxSearchCount,
                      decoration: _settingsFieldDecoration(
                        l10n.defaultMaxSearchCount,
                      ),
                      onChanged: settings.setDefaultMaxSearchCount,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.defaultMaxSearchCountHint,
                      style: _hintTextStyle(context),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.sectionLanguage, style: sectionTitleStyle),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: SettingsService.instance,
              builder: (context, _) {
                return InputDecorator(
                  decoration: _settingsFieldDecoration(l10n.language),
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
              onTap: () => clearWithConfirm(
                context,
                title: l10n.confirmClearFavorites,
                message: l10n.confirmClearFavoritesMessage,
                onClear: FavoritesService.instance.clearAll,
                successMessage: l10n.favoritesCleared,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.push_pin_outlined),
              title: Text(l10n.clearAllQuickPins),
              subtitle: Text(l10n.clearAllQuickPinsSubtitle),
              onTap: () => clearWithConfirm(
                context,
                title: l10n.confirmClearQuickPins,
                message: l10n.confirmClearQuickPinsMessage,
                onClear: QuickPinService.instance.clearAll,
                successMessage: l10n.quickPinsCleared,
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.sectionAppInfo, style: sectionTitleStyle),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  const AppLogo(size: 72, borderRadius: 16),
                  const SizedBox(height: 12),
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.appDescription,
                    textAlign: TextAlign.center,
                    style: _hintTextStyle(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.dataProvider),
              subtitle: Text(l10n.dataProviderValue),
            ),
            const StudioCredit(),
          ],
        ),
      ),
    );
  }
}
