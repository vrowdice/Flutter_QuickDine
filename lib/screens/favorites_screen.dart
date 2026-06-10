import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/shop.dart';
import '../services/favorites_service.dart';
import '../widgets/screen_with_credit.dart';
import '../widgets/shop_list_tile.dart';
import 'detail_screen.dart';

/// 저장된 즐겨찾기 목록 화면
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ScreenWithCredit(
        child: ListenableBuilder(
          listenable: FavoritesService.instance,
          builder: (context, _) {
            final favorites = FavoritesService.instance.favorites;

            if (favorites.isEmpty) {
              return Center(
                child: Text(
                  l10n.favoritesEmpty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final shop = favorites[index];
                return ShopListTile(
                  shop: shop,
                  onTap: () async {
                    final result = await Navigator.push<Shop>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(shop: shop),
                      ),
                    );
                    if (result != null && context.mounted) {
                      Navigator.pop(context, result);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
