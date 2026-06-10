import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/shop.dart';
import '../services/favorites_service.dart';

/// 즐겨찾기 추가/해제 아이콘 버튼
class FavoriteIconButton extends StatelessWidget {
  final Shop shop;

  const FavoriteIconButton({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final isFavorite = FavoritesService.instance.isFavorite(shop);
        return IconButton(
          tooltip: isFavorite ? l10n.removeFavorite : l10n.addFavorite,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () => FavoritesService.instance.toggle(shop),
        );
      },
    );
  }
}
