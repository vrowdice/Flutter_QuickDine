import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'constants/api_constants.dart';
import 'services/favorites_service.dart';
import 'services/maps_key_service.dart';
import 'services/quick_pin_service.dart';
import 'services/settings_service.dart';

/// 앱 진입점: env 로드 → Maps 키 초기화 → 로컬 데이터 로드 → QuickDineApp 실행
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ApiConstants.envAssetPath);
  await MapsKeyService.initialize();
  await FavoritesService.instance.init();
  await QuickPinService.instance.init();
  await SettingsService.instance.init();
  runApp(const QuickDineApp());
}
