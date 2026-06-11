import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/shop.dart';
import 'hot_pepper_credit_bar.dart';
import 'shop_list_tile.dart';

/// 화면 하단 DraggableScrollableSheet — Google Maps 스타일 검색 결과 목록
class SearchResultsSheet extends StatefulWidget {
  final List<Shop> shops;
  final ValueChanged<Shop> onShopTap;
  final VoidCallback onDismissed;
  final ValueChanged<double>? onExtentChanged;

  const SearchResultsSheet({
    super.key,
    required this.shops,
    required this.onShopTap,
    required this.onDismissed,
    this.onExtentChanged,
  });

  /// 시트 기본 높이 비율 — 지도 padding 계산과 동일 값 유지
  static const double initialChildSize = 0.3;
  static const double maxChildSize = 0.8;

  @override
  State<SearchResultsSheet> createState() => _SearchResultsSheetState();
}

class _SearchResultsSheetState extends State<SearchResultsSheet> {
  final _sheetController = DraggableScrollableController();
  bool _isAnimatingClose = false;

  @override
  void initState() {
    super.initState();
    // 맨 아래로 스와이프해 min(0)에 닿으면 시트 완전히 숨김
    _sheetController.addListener(_onSheetExtentChanged);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetExtentChanged);
    _sheetController.dispose();
    super.dispose();
  }

  void _onSheetExtentChanged() {
    if (!_sheetController.isAttached || _isAnimatingClose) return;

    widget.onExtentChanged?.call(_sheetController.size);

    if (_sheetController.size <= 0.01) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onDismissed();
      });
    }
  }

  /// 닫기 버튼 — 아래로 슬라이드 애니메이션 후 unmount
  Future<void> _closeSheet() async {
    if (_isAnimatingClose || !mounted) return;
    _isAnimatingClose = true;

    try {
      if (_sheetController.isAttached) {
        await _sheetController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } finally {
      _isAnimatingClose = false;
    }

    if (mounted) widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: SearchResultsSheet.initialChildSize,
      minChildSize: 0,
      maxChildSize: SearchResultsSheet.maxChildSize,
      snap: true,
      snapSizes: const [0, SearchResultsSheet.initialChildSize, SearchResultsSheet.maxChildSize],
      builder: (context, scrollController) {
        return Material(
          elevation: 12,
          shadowColor: Colors.black38,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              const SizedBox(height: 8),
              // 핸들은 정중앙, 닫기 버튼은 우측 — 서로 정렬에 영향 없음
              SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: _SheetDragHandle(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: _closeSheet,
                        tooltip: l10n.close,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.searchResults(widget.shops.length),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: widget.shops.length + 1,
                  separatorBuilder: (context, index) {
                    if (index >= widget.shops.length - 1) {
                      return const SizedBox.shrink();
                    }
                    return const Divider(height: 1);
                  },
                  itemBuilder: (context, index) {
                    if (index == widget.shops.length) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: HotPepperCreditBar(),
                      );
                    }
                    final shop = widget.shops[index];
                    return ShopListTile(
                      shop: shop,
                      onTap: () => widget.onShopTap(shop),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  const _SheetDragHandle();

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
