import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../constants/search_count.dart';
import '../constants/search_radius.dart';
import '../models/shop.dart';

/// HotPepper Gourmet Search API 통신을 담당하는 서비스
class HotPepperApi {
  String get _apiKey {
    final key = dotenv.env[ApiConstants.envApiKeyName];
    if (key == null || key.isEmpty || key == 'YOUR_API_KEY') {
      throw Exception(
        'Set ${ApiConstants.envApiKeyName} in assets/env (see assets/env.example).',
      );
    }
    return key;
  }

  /// [count]: API `count` — max count로 1회 요청량 제한 (3000m 대량 방어)
  /// [range]: HotPepper `range` 1~5 (300m~3000m)
  /// [genre]: HotPepper `genre` 코드 (예: G001). null이면 파라미터 생략
  /// [parking]: true → `parking=1`
  /// [privateRoom]: true → `private_room=1`
  Future<List<Shop>> searchShops({
    required double lat,
    required double lng,
    required int count,
    int range = kDefaultSearchRadius,
    String? genre,
    bool parking = false,
    bool privateRoom = false,
  }) async {
    final safeCount = clampSearchCount(count).clamp(1, ApiConstants.maxResultCount);
    final safeRange = clampSearchRadius(range);

    final queryParameters = <String, String>{
      'key': _apiKey,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'range': safeRange.toString(),
      'format': 'json',
      'count': safeCount.toString(),
    };
    if (genre != null && genre.isNotEmpty) {
      queryParameters['genre'] = genre;
    }
    if (parking) {
      queryParameters['parking'] = '1';
    }
    if (privateRoom) {
      queryParameters['private_room'] = '1';
    }

    final uri = Uri.parse(ApiConstants.hotPepperApiBaseUrl).replace(
      queryParameters: queryParameters,
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('HotPepper API error: HTTP ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return _parseShops(data);
  }

  List<Shop> _parseShops(Map<String, dynamic> data) {
    final results = data['results'] as Map<String, dynamic>?;
    if (results == null) {
      throw Exception('Invalid HotPepper API response format.');
    }

    final available = int.tryParse('${results['results_available']}') ?? 0;
    if (available == 0) return [];

    final shopData = results['shop'];
    final List<dynamic> shopList;
    if (shopData is List) {
      shopList = shopData;
    } else if (shopData is Map<String, dynamic>) {
      shopList = [shopData];
    } else {
      return [];
    }

    return shopList
        .map((item) => Shop.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
