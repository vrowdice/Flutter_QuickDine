import 'package:flutter/material.dart';

import '../constants/search_radius.dart';
import '../l10n/app_localizations.dart';

/// HotPepper range(1~5) 검색 반경 선택 드롭다운
class SearchRadiusDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final InputDecoration decoration;

  const SearchRadiusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.decoration = const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final safeValue = clampSearchRadius(value);

    return InputDecorator(
      decoration: decoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: safeValue,
          items: kSearchRadiusRanges
              .map(
                (range) => DropdownMenuItem<int>(
                  value: range,
                  child: Text(
                    l10n.searchRadiusMeters(searchRadiusMeters(range)),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged == null
              ? null
              : (range) {
                  if (range != null) onChanged!(range);
                },
        ),
      ),
    );
  }
}
