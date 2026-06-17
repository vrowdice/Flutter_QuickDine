/// 결과 시트 높이 비율에 따른 지도·패널·검색 버튼 inset
class SearchOverlayMetrics {
  const SearchOverlayMetrics({
    required this.mapBottomPadding,
    required this.panelBottomInset,
    required this.searchPillBottom,
  });

  static const creditBarInset = 44.0;

  /// [SearchPillButton.verticalMargin]과 동일
  static const searchPillVerticalMargin = 16.0;

  final double mapBottomPadding;
  final double panelBottomInset;
  final double searchPillBottom;

  factory SearchOverlayMetrics.from({
    required bool sheetVisible,
    required double sheetExtent,
    required double stackHeight,
  }) {
    final sheetTop = sheetVisible ? sheetExtent * stackHeight : 0.0;
    final fallbackInset = sheetVisible ? sheetTop : creditBarInset;

    return SearchOverlayMetrics(
      mapBottomPadding: sheetVisible ? sheetTop : 0,
      panelBottomInset: fallbackInset + 8,
      searchPillBottom: fallbackInset + searchPillVerticalMargin,
    );
  }
}
