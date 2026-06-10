import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// 화면 하단 중앙 플로팅 검색 버튼 — Google Maps 스타일 Pill
class SearchPillButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const SearchPillButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  /// 지도 bottom padding 계산용 (버튼 높이 + 여백)
  static const double estimatedHeight = 52;
  static const double verticalMargin = 16;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 6,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(28),
      color: colorScheme.primary,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.onPrimary,
                  ),
                )
              else
                Icon(Icons.search, color: colorScheme.onPrimary, size: 22),
              const SizedBox(width: 10),
              Text(
                isLoading ? l10n.searching : l10n.searchPill,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
