import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/shop.dart';
import '../services/favorites_service.dart';

/// 즐겨찾기 추가/해제 아이콘 버튼
class FavoriteIconButton extends StatelessWidget {
  final Shop shop;

  /// 목록 상위에서 즐겨찾기 상태를 한 번에 구독할 때 전달 — 개별 리스너 생략
  final bool? isFavorite;

  const FavoriteIconButton({
    super.key,
    required this.shop,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isFavorite != null) {
      return _buildButton(l10n, isFavorite!);
    }

    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        return _buildButton(
          l10n,
          FavoritesService.instance.isFavorite(shop),
        );
      },
    );
  }

  Widget _buildButton(AppLocalizations l10n, bool favorite) {
    return IconButton(
      tooltip: favorite ? l10n.removeFavorite : l10n.addFavorite,
      icon: Icon(
        favorite ? Icons.favorite : Icons.favorite_border,
        color: favorite ? Colors.red : null,
      ),
      onPressed: () => FavoritesService.instance.toggle(shop),
    );
  }
}
