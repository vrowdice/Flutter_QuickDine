import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_constants.dart';
import 'favorites_service.dart';
import 'maps_key_service.dart';
import 'quick_pin_service.dart';
import 'settings_service.dart';

/// 앱 시작 시 1회 실행되는 초기화 (스플래시에서 호출)
class AppBootstrap {
  AppBootstrap._();

  static Future<void>? _future;

  static Future<void> ensureInitialized() {
    return _future ??= _run();
  }

  static Future<void> _run() async {
    await dotenv.load(fileName: ApiConstants.envAssetPath);
    await MapsKeyService.initialize();
    await FavoritesService.instance.init();
    await QuickPinService.instance.init();
    await SettingsService.instance.init();
  }
}
