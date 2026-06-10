import 'package:flutter/material.dart';

import '../constants/search_count.dart';
import '../l10n/app_localizations.dart';

/// 최대 검색 개수 선택 드롭다운
class SearchCountDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final InputDecoration decoration;

  const SearchCountDropdown({
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

    return InputDecorator(
      decoration: decoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: clampSearchCount(value),
          items: kSearchCountOptions
              .map(
                (count) => DropdownMenuItem<int>(
                  value: count,
                  child: Text(l10n.searchCountOption(count)),
                ),
              )
              .toList(),
          onChanged: onChanged == null
              ? null
              : (count) {
                  if (count != null) onChanged!(count);
                },
        ),
      ),
    );
  }
}
