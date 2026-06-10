import 'package:flutter/material.dart';

import '../models/shop.dart';
import 'favorite_icon_button.dart';
import 'hot_pepper_image_credit.dart';

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
                    const Icon(Icons.restaurant, size: 40),
              ),
            )
          : const Icon(Icons.restaurant, size: 40),
      title: Text(
        shop.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(shop.access),
          if (shop.logoImage.isNotEmpty) const HotPepperImageCredit(),
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
