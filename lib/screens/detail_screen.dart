import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/shop.dart';
import '../widgets/detail_row.dart';
import '../widgets/favorite_icon_button.dart';
import '../widgets/hot_pepper_image_credit.dart';
import '../widgets/screen_with_credit.dart';

/// 화면 3: 점포 상세 화면 (Detail Screen)
class DetailScreen extends StatelessWidget {
  final Shop shop;

  const DetailScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shopDetail),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (shop.hasLocation)
            IconButton(
              onPressed: () => Navigator.pop(context, shop),
              tooltip: l10n.showOnMap,
              icon: const Icon(Icons.map),
            ),
          FavoriteIconButton(shop: shop),
        ],
      ),
      body: ScreenWithCredit(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (shop.photoUrl.isNotEmpty) ...[
                Image.network(
                  shop.photoUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 64),
                  ),
                ),
                const HotPepperImageCredit(),
              ] else
                Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant, size: 64),
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),

                    DetailSection(
                      icon: Icons.location_on,
                      label: l10n.address,
                      value: shop.address,
                    ),
                    const SizedBox(height: 20),
                    DetailSection(
                      icon: Icons.access_time,
                      label: l10n.businessHours,
                      value: shop.open,
                    ),
                    const SizedBox(height: 20),
                    DetailSection(
                      icon: Icons.directions_walk,
                      label: l10n.access,
                      value: shop.access,
                      splitPattern: accessSplitPattern,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
