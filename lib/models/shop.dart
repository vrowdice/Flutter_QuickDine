/// HotPepper API JSON 응답을 Dart 객체로 변환하는 Shop 모델
class Shop {
  final String id;
  final String name;
  final String access;
  final String logoImage;
  final String address;
  final String open;
  final String photoUrl;
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
    this.lat,
    this.lng,
  });

  bool get hasLocation => lat != null && lng != null;

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
      name: json['name'] as String? ?? '이름 없음',
      access: json['access'] as String? ?? '접근 정보 없음',
      logoImage: json['logo_image'] as String? ?? '',
      address: json['address'] as String? ?? '주소 정보 없음',
      open: json['open'] as String? ?? '영업시간 정보 없음',
      photoUrl: photoUrl,
      lat: _parseCoord(json['lat']),
      lng: _parseCoord(json['lng']),
    );
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
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      };
}
