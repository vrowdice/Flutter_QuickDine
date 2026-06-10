import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/search_count.dart';
import '../constants/search_radius.dart';

/// 앱 설정 로컬 저장 (shared_preferences)
class SettingsService extends ChangeNotifier {
  SettingsService._();

  static final SettingsService instance = SettingsService._();

  static const _maxSearchCountKey = 'search_max_count';
  static const _searchRangeKey = 'search_range';
  static const _localeKey = 'app_locale';

  static const supportedLanguageCodes = ['system', 'ko', 'ja', 'en'];

  int _defaultMaxSearchCount = kDefaultSearchCount;
  int _defaultSearchRadius = kDefaultSearchRadius;
  Locale? _locale;

  int get defaultMaxSearchCount => _defaultMaxSearchCount;

  int get defaultSearchRadius => _defaultSearchRadius;

  Locale? get locale => _locale;

  String get localeCode => _locale?.languageCode ?? 'system';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _defaultMaxSearchCount = clampSearchCount(
      prefs.getInt(_maxSearchCountKey) ?? kDefaultSearchCount,
    );
    _defaultSearchRadius = clampSearchRadius(
      prefs.getInt(_searchRangeKey) ?? kDefaultSearchRadius,
    );

    final code = prefs.getString(_localeKey);
    if (code != null && code != 'system') {
      _locale = Locale(code);
    }
    notifyListeners();
  }

  Future<void> setDefaultMaxSearchCount(int count) async {
    _defaultMaxSearchCount = clampSearchCount(count);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxSearchCountKey, _defaultMaxSearchCount);
    notifyListeners();
  }

  Future<void> setDefaultSearchRadius(int range) async {
    _defaultSearchRadius = clampSearchRadius(range);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_searchRangeKey, _defaultSearchRadius);
    notifyListeners();
  }

  Future<void> setLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == 'system') {
      _locale = null;
      await prefs.remove(_localeKey);
    } else {
      _locale = Locale(code);
      await prefs.setString(_localeKey, code);
    }
    notifyListeners();
  }
}
