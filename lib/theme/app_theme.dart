import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// QuickDine brand palette — warm primary + muted sage secondary
abstract final class AppColors {
  static const primary = Color(0xFFC4683A);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFFE8DE);
  static const onPrimaryContainer = Color(0xFF3A1505);

  static const secondary = Color(0xFF3D6B5C);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFD4E8E0);
  static const onSecondaryContainer = Color(0xFF0A2319);

  static const surface = Color(0xFFFBF9F7);
  static const onSurface = Color(0xFF1C1B19);
  static const onSurfaceVariant = Color(0xFF5C5A57);
  static const outline = Color(0xFFC9C5C0);
  static const outlineVariant = Color(0xFFE3DFDB);
  static const surfaceContainerHigh = Color(0xFFF0EDEA);
  static const surfaceContainerHighest = Color(0xFFE8E4E0);
}

ColorScheme _lightColorScheme() {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: Color(0xFF7A6B4E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF0E6D4),
    onTertiaryContainer: Color(0xFF2A2210),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF31302E),
    onInverseSurface: Color(0xFFF4F0EC),
    inversePrimary: Color(0xFFFFB596),
    surfaceTint: AppColors.primary,
  );
}

/// Noto Sans / Noto Sans KR / Noto Sans JP — locale-aware app theme
ThemeData buildAppTheme({Locale? locale}) {
  final colorScheme = _lightColorScheme();
  final base = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      surfaceTintColor: colorScheme.primary,
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      actionsIconTheme: IconThemeData(color: colorScheme.onPrimary),
      titleTextStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black26,
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.secondary, width: 1.5),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.secondary,
      textColor: colorScheme.onSurface,
    ),
    iconTheme: IconThemeData(color: colorScheme.secondary),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 3,
    ),
  );

  final TextTheme textTheme;
  final String? fontFamily;
  final List<String> fontFamilyFallback;

  switch (locale?.languageCode) {
    case 'ko':
      textTheme = GoogleFonts.notoSansKrTextTheme(base.textTheme);
      fontFamily = GoogleFonts.notoSansKr().fontFamily;
      fontFamilyFallback = _fallbackFamilies(
        GoogleFonts.notoSans(),
        GoogleFonts.notoSansJp(),
      );
    case 'ja':
      textTheme = GoogleFonts.notoSansJpTextTheme(base.textTheme);
      fontFamily = GoogleFonts.notoSansJp().fontFamily;
      fontFamilyFallback = _fallbackFamilies(
        GoogleFonts.notoSans(),
        GoogleFonts.notoSansKr(),
      );
    default:
      textTheme = GoogleFonts.notoSansTextTheme(base.textTheme);
      fontFamily = GoogleFonts.notoSans().fontFamily;
      fontFamilyFallback = _fallbackFamilies(
        GoogleFonts.notoSansKr(),
        GoogleFonts.notoSansJp(),
      );
  }

  final themedText = textTheme.apply(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  );

  return base.copyWith(
    textTheme: themedText,
    primaryTextTheme: themedText,
    appBarTheme: base.appBarTheme.copyWith(
      titleTextStyle: themedText.titleLarge?.copyWith(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
  );
}

List<String> _fallbackFamilies(TextStyle a, TextStyle b) {
  return [
    if (a.fontFamily != null) a.fontFamily!,
    if (b.fontFamily != null) b.fontFamily!,
  ];
}

/// Settings locale, or device locale when set to "system"
Locale resolveAppLocale(Locale? settingsLocale) {
  return settingsLocale ??
      WidgetsBinding.instance.platformDispatcher.locale;
}
