import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/shop.dart';
import '../utils/url_launcher_helpers.dart';

/// 점포 상세 — 전화·웹 액션 버튼
class ShopDetailActions extends StatelessWidget {
  final Shop shop;

  const ShopDetailActions({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    if (!shop.hasPhone && !shop.hasShopUrl) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (shop.hasPhone)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _onCallPressed(context, l10n),
              icon: const Icon(Icons.phone_outlined, size: 18),
              label: Text(l10n.detailCall),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        if (shop.hasPhone && shop.hasShopUrl) const SizedBox(width: 12),
        if (shop.hasShopUrl)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _onWebPressed(context, l10n),
              icon: const Icon(Icons.language, size: 18),
              label: Text(l10n.detailWeb),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.secondary,
                side: BorderSide(color: colorScheme.secondary.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onCallPressed(BuildContext context, AppLocalizations l10n) async {
    final ok = await launchPhoneCall(shop.phone);
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.launchPhoneFailed)),
    );
  }

  Future<void> _onWebPressed(BuildContext context, AppLocalizations l10n) async {
    final ok = await launchExternalWebUrl(shop.shopUrl);
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.launchWebFailed)),
    );
  }
}
