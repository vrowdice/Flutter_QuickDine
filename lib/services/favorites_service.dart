import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/shop.dart';

/// 즐겨찾기 로컬 저장 서비스 (shared_preferences)
class FavoritesService extends ChangeNotifier {
  FavoritesService._();

  static final FavoritesService instance = FavoritesService._();

  static const _storageKey = 'favorite_shops';

  List<Shop> _favorites = [];

  List<Shop> get favorites => List.unmodifiable(_favorites);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    _favorites = raw
        .map((item) => Shop.fromJson(json.decode(item) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  bool isFavorite(Shop shop) =>
      _favorites.any((item) => item.favoriteKey == shop.favoriteKey);

  Future<void> toggle(Shop shop) async {
    final index =
        _favorites.indexWhere((item) => item.favoriteKey == shop.favoriteKey);

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(shop);
    }

    await _save();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _favorites = [];
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        _favorites.map((shop) => json.encode(shop.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }
}
