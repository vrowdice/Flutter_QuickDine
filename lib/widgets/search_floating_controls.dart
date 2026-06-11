import 'package:flutter/material.dart';

import '../constants/search_genre.dart';
import '../l10n/app_localizations.dart';
import '../utils/l10n_helpers.dart';
import 'search_count_dropdown.dart';
import 'search_radius_dropdown.dart';

/// 지도 상단 통합 검색 패널 — 반경·개수 드롭다운 + 장르 필터
class SearchFloatingControls extends StatelessWidget {
  final int selectedRadius;
  final int selectedMaxCount;
  final String? selectedGenreCode;
  final bool isLoading;
  final ValueChanged<int>? onRadiusChanged;
  final ValueChanged<int>? onMaxCountChanged;
  final ValueChanged<String?>? onGenreChanged;

  const SearchFloatingControls({
    super.key,
    required this.selectedRadius,
    required this.selectedMaxCount,
    required this.selectedGenreCode,
    required this.isLoading,
    required this.onRadiusChanged,
    required this.onMaxCountChanged,
    required this.onGenreChanged,
  });

  /// 플로팅 카드 좌우 여백 — 퀵핀 버튼 left 정렬과 동일
  static const double horizontalMargin = 12;

  static const double _outerTopPadding = 8;
  static const double _outerBottomPadding = 4;
  static const double _innerPaddingV = 6;
  static const double _dropdownRowHeight = 56;
  static const double _rowGap = 8;
  static const double _chipRowHeight = 30;

  /// 패널 전체 높이 — 지도 top 패딩·퀵핀 위치 계산용
  static const double estimatedHeight = _outerTopPadding +
      _innerPaddingV +
      _dropdownRowHeight +
      _rowGap +
      _chipRowHeight +
      _innerPaddingV +
      _outerBottomPadding;

  /// 검색 패널 아래 퀵핀·내 위치 버튼 간격
  static const double quickPinGapBelowBar = 12;

  static const _compactDecoration = InputDecoration(
    isDense: true,
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        horizontalMargin,
        _outerTopPadding,
        horizontalMargin,
        _outerBottomPadding,
      ),
      child: Material(
        elevation: 3,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface.withValues(alpha: 0.96),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.fromLTRB(8, _innerPaddingV, 8, _innerPaddingV),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: _dropdownRowHeight,
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
              const SizedBox(height: _rowGap),
              SizedBox(
                height: _chipRowHeight,
                child: _GenreChipRow(
                  selectedGenreCode: selectedGenreCode,
                  isLoading: isLoading,
                  onGenreChanged: onGenreChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenreChipRow extends StatelessWidget {
  final String? selectedGenreCode;
  final bool isLoading;
  final ValueChanged<String?>? onGenreChanged;

  const _GenreChipRow({
    required this.selectedGenreCode,
    required this.isLoading,
    required this.onGenreChanged,
  });

  static const double _scrollPaddingH = 16;
  static const double _chipSpacing = 8;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: _scrollPaddingH),
      itemCount: kSearchGenreOptions.length,
      separatorBuilder: (_, _) => const SizedBox(width: _chipSpacing),
      itemBuilder: (context, index) {
        final option = kSearchGenreOptions[index];
        final isSelected = selectedGenreCode == option.code;
        final label = genreLabel(l10n, option.code);

        return ChoiceChip(
          label: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          showCheckmark: false,
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          labelPadding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
          side: BorderSide.none,
          selectedColor: colorScheme.primary,
          backgroundColor: Colors.grey.shade200,
          onSelected: isLoading
              ? null
              : (_) => onGenreChanged?.call(option.code),
        );
      },
    );
  }
}
