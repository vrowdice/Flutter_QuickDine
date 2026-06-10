import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quick_pin.dart';

/// 퀵핀 로컬 저장 서비스 (shared_preferences)
class QuickPinService extends ChangeNotifier {
  QuickPinService._();

  static final QuickPinService instance = QuickPinService._();

  static const _storageKey = 'quick_pins';

  List<QuickPin> _pins = [];

  List<QuickPin> get pins => List.unmodifiable(_pins);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    _pins = raw
        .map((item) => QuickPin.fromJson(json.decode(item) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  /// 현재 지도 좌표를 퀵핀으로 저장
  Future<void> add({
    required String name,
    required double lat,
    required double lng,
  }) async {
    final pin = QuickPin(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      lat: lat,
      lng: lng,
    );
    _pins.add(pin);
    await _save();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _pins.removeWhere((pin) => pin.id == id);
    await _save();
    notifyListeners();
  }

  /// 저장된 퀵핀 전체 삭제
  Future<void> clearAll() async {
    _pins = [];
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _pins.map((pin) => json.encode(pin.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }
}
