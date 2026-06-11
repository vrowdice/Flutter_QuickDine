import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../l10n/app_localizations.dart';

/// 설정 등 — Developed by Vrowdice 스튜디오 크레딧
class StudioCredit extends StatelessWidget {
  const StudioCredit({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        Divider(color: colorScheme.outlineVariant),
        const SizedBox(height: 20),
        Text(
          l10n.developedBy,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Image.asset(
          AppAssets.vrowdiceLogoBlack,
          height: 36,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
