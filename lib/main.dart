import 'package:flutter/material.dart';

import 'app.dart';

/// 앱 진입점 — 초기화는 [SplashScreen]에서 수행
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuickDineApp());
}
