import 'package:flutter/material.dart';

import '../models/shop.dart';
import '../screens/detail_screen.dart';

/// 상세 화면을 열고, 지도 표시를 요청하면 [Shop]을 반환
Future<Shop?> pushShopDetail(BuildContext context, Shop shop) {
  return Navigator.push<Shop>(
    context,
    MaterialPageRoute(builder: (_) => DetailScreen(shop: shop)),
  );
}
