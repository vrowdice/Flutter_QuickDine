import 'package:flutter/material.dart';

import '../models/shop.dart';
import 'app_logo.dart';
import 'favorite_icon_button.dart';

/// 검색 결과·즐겨찾기 공통 식당 목록 타일
class ShopListTile extends StatelessWidget {
  final Shop shop;
  final VoidCallback onTap;

  const ShopListTile({
    super.key,
    required this.shop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: shop.logoImage.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                shop.logoImage,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const AppLogo(size: 56, borderRadius: 4),
              ),
            )
          : const AppLogo(size: 56, borderRadius: 4),
      title: Text(
        shop.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shop.genreName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                shop.genreName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.secondary,
                ),
              ),
            ),
          Text(
            shop.access,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FavoriteIconButton(shop: shop),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}
