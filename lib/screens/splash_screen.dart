import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../services/app_bootstrap.dart';
import '../theme/app_theme.dart';
import 'search_screen.dart';

/// 스튜디오 로고 스플래시 — 초기화 완료 후 메인 화면으로 전환
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration minDisplayDuration = Duration(milliseconds: 1200);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.wait([
      AppBootstrap.ensureInitialized(),
      Future<void>.delayed(SplashScreen.minDisplayDuration),
    ]);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          AppAssets.vrowdiceLogoWhite,
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
