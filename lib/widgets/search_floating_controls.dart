import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'search_count_dropdown.dart';
import 'search_radius_dropdown.dart';

/// 지도 상단 플로팅 검색 컨트롤 — 반경·개수 선택
class SearchFloatingControls extends StatelessWidget {
  final int selectedRadius;
  final int selectedMaxCount;
  final bool isLoading;
  final ValueChanged<int>? onRadiusChanged;
  final ValueChanged<int>? onMaxCountChanged;

  const SearchFloatingControls({
    super.key,
    required this.selectedRadius,
    required this.selectedMaxCount,
    required this.isLoading,
    required this.onRadiusChanged,
    required this.onMaxCountChanged,
  });

  /// 플로팅 카드 좌우 여백 — 퀵핀 버튼 left 정렬과 동일
  static const double horizontalMargin = 12;

  /// 플로팅 카드 높이(패딩 포함) — 지도 top 패딩·퀵핀 위치 계산용
  static const double blockVerticalPadding = 12;
  static const double cardHeight = 56;
  static const double estimatedHeight = blockVerticalPadding + cardHeight;

  /// 검색 바 아래 퀵핀·내 위치 버튼 간격
  static const double quickPinGapBelowBar = 12;

  static const _compactDecoration = InputDecoration(
    isDense: true,
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surface = Theme.of(context).colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        horizontalMargin,
        8,
        horizontalMargin,
        4,
      ),
      child: Material(
        elevation: 4,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        color: surface.withValues(alpha: 0.94),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: SearchRadiusDropdown(
                  value: selectedRadius,
                  onChanged: onRadiusChanged,
                  decoration: _compactDecoration.copyWith(
                    labelText: l10n.searchRadius,
                    labelStyle: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 4,
                child: SearchCountDropdown(
                  value: selectedMaxCount,
                  onChanged: onMaxCountChanged,
                  decoration: _compactDecoration.copyWith(
                    labelText: l10n.searchMaxCount,
                    labelStyle: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
