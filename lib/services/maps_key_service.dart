import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_constants.dart';

/// Google Maps API 키 초기화
/// - Android: Gradle이 assets/env → AndroidManifest에 주입
/// - iOS: main()에서 env 값을 네이티브로 전달
class MapsKeyService {
  static const _channel = MethodChannel('quick_dine/maps_key');

  static Future<void> initialize() async {
    final key = dotenv.env[ApiConstants.envGoogleMapsApiKeyName];
    if (key == null || key.isEmpty || key == 'YOUR_GOOGLE_MAPS_API_KEY') {
      throw Exception(
        'Set ${ApiConstants.envGoogleMapsApiKeyName} in assets/env (see assets/env.example).',
      );
    }

    if (Platform.isIOS) {
      await _channel.invokeMethod<void>('setApiKey', key);
    }
  }
}
