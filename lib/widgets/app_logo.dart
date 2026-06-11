import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

/// QuickDine 앱 아이콘 — AppBar·설정 등 공통 표시
class AppLogo extends StatelessWidget {
  final double size;
  final double borderRadius;

  const AppLogo({
    super.key,
    this.size = 28,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        AppAssets.appIcon,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Icon(
          Icons.restaurant,
          size: size * 0.85,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
