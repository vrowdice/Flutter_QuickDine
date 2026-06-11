import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'services/settings_service.dart';
import 'theme/app_theme.dart';

/// 앱 루트: MaterialApp, 테마, 로케일, 초기 화면 설정
class QuickDineApp extends StatelessWidget {
  const QuickDineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService.instance,
      builder: (context, _) {
        final locale = resolveAppLocale(SettingsService.instance.locale);

        return MaterialApp(
          title: 'QuickDine',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(locale: locale),
          locale: SettingsService.instance.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        );
      },
    );
  }
}
