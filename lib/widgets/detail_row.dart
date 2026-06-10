import 'package:flutter/material.dart';

/// 상세 화면 문자열 분리 — 기본: 쉼표(`,` / `、`)
List<String> splitDetailSegments(String text, {RegExp? pattern}) {
  return text
      .split(pattern ?? _defaultSplitPattern)
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();
}

final _defaultSplitPattern = RegExp(r'[,、]');

/// 접근 정보용 — 쉼표 + 슬래시(`/`, `／`)로 구분되는 경우가 많음
final accessSplitPattern = RegExp(r'[,、/／]');

/// 상세 화면 정보 블록 — 구분자로 나뉜 값은 항목별로 나눠 표시
class DetailSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final RegExp splitPattern;

  DetailSection({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    RegExp? splitPattern,
  }) : splitPattern = splitPattern ?? _defaultSplitPattern;

  @override
  Widget build(BuildContext context) {
    final segments = splitDetailSegments(value, pattern: splitPattern);
    final items = segments.isEmpty ? [value] : segments;
    final colorScheme = Theme.of(context).colorScheme;
    final boxColor = colorScheme.primaryContainer.withValues(alpha: 0.35);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.orange),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              ...items.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(top: entry.key > 0 ? 8 : 0),
                  child: _ValueBox(
                    text: entry.value,
                    color: boxColor,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValueBox extends StatelessWidget {
  final String text;
  final Color color;

  const _ValueBox({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.circle, size: 6, color: Colors.orange),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
