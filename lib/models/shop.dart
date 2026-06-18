/// HotPepper API JSON 응답을 Dart 객체로 변환하는 Shop 모델
class Shop {
  final String id;
  final String name;
  final String access;
  final String logoImage;
  final String address;
  final String open;
  final String photoUrl;
  final String phone;
  final String shopUrl;
  final String budget;
  final String genreName;
  final String catchPhrase;
  final double? lat;
  final double? lng;

  Shop({
    required this.id,
    required this.name,
    required this.access,
    required this.logoImage,
    required this.address,
    required this.open,
    required this.photoUrl,
    this.phone = '',
    this.shopUrl = '',
    this.budget = '',
    this.genreName = '',
    this.catchPhrase = '',
    this.lat,
    this.lng,
  });

  bool get hasLocation => lat != null && lng != null;
  bool get hasPhone => phone.isNotEmpty;
  bool get hasShopUrl => shopUrl.isNotEmpty;
  bool get hasBudget => budget.isNotEmpty;

  /// 상세 화면 부제 — `[장르명] 캐치프레이즈` (둘 중 하나만 있어도 표시)
  String? get shopSubtitle {
    final hasGenre = genreName.isNotEmpty;
    final hasCatch = catchPhrase.isNotEmpty;
    if (!hasGenre && !hasCatch) return null;
    if (hasGenre && hasCatch) return '[$genreName] $catchPhrase';
    if (hasGenre) return '[$genreName]';
    return catchPhrase;
  }

  bool get hasSubtitle => shopSubtitle != null;

  String get favoriteKey =>
      id.isNotEmpty ? id : '$name|$address';

  factory Shop.fromJson(Map<String, dynamic> json) {
    String photoUrl = json['photo_url'] as String? ?? '';
    if (photoUrl.isEmpty) {
      final photo = json['photo'];
      if (photo is Map<String, dynamic>) {
        final pc = photo['pc'];
        if (pc is Map<String, dynamic>) {
          photoUrl = (pc['l'] ?? pc['m'] ?? pc['s'] ?? '') as String;
        }
      }
    }

    return Shop(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      access: json['access'] as String? ?? '',
      logoImage: json['logo_image'] as String? ?? '',
      address: json['address'] as String? ?? '',
      open: json['open'] as String? ?? '',
      photoUrl: photoUrl,
      phone: json['phone'] as String? ?? '',
      shopUrl: _parseShopUrl(json),
      budget: _parseBudget(json),
      genreName: _parseGenreName(json),
      catchPhrase: json['catch'] as String? ?? '',
      lat: _parseCoord(json['lat']),
      lng: _parseCoord(json['lng']),
    );
  }

  static String _parseShopUrl(Map<String, dynamic> json) {
    final urls = json['urls'];
    if (urls is! Map<String, dynamic>) return '';

    for (final key in ['smart_phone', 'mobile', 'pc']) {
      final value = urls[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return '';
  }

  static String _parseGenreName(Map<String, dynamic> json) {
    final genre = json['genre'];
    if (genre is Map<String, dynamic>) {
      return genre['name'] as String? ?? '';
    }
    return '';
  }

  static String _parseBudget(Map<String, dynamic> json) {
    final budget = json['budget'];
    if (budget is! Map<String, dynamic>) return '';

    final name = budget['name'] as String? ?? '';
    if (name.isNotEmpty) return name;

    final average = budget['average'];
    if (average != null && average.toString().isNotEmpty) {
      return average.toString();
    }
    return '';
  }

  static double? _parseCoord(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'access': access,
        'logo_image': logoImage,
        'address': address,
        'open': open,
        'photo_url': photoUrl,
        if (phone.isNotEmpty) 'phone': phone,
        if (shopUrl.isNotEmpty)
          'urls': {
            'pc': shopUrl,
          },
        if (budget.isNotEmpty)
          'budget': {
            'name': budget,
          },
        if (genreName.isNotEmpty)
          'genre': {
            'name': genreName,
          },
        if (catchPhrase.isNotEmpty) 'catch': catchPhrase,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      };
}
