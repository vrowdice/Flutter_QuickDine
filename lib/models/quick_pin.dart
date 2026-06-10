/// 사용자가 저장한 검색 위치 (퀵핀)
class QuickPin {
  final String id;
  final String name;
  final double lat;
  final double lng;

  QuickPin({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory QuickPin.fromJson(Map<String, dynamic> json) {
    return QuickPin(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': lat,
        'lng': lng,
      };
}
