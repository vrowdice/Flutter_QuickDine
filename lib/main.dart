import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────
// HotPepper API 키 (나중에 실제 키로 교체하세요)
// ─────────────────────────────────────────────
const String kApiKey = 'YOUR_API_KEY';

// HotPepper Gourmet Search API 엔드포인트
const String kApiBaseUrl =
    'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/';

void main() {
  runApp(const QuickDineApp());
}

// ─────────────────────────────────────────────
// 앱 진입점: MaterialApp으로 3개 화면을 연결
// ─────────────────────────────────────────────
class QuickDineApp extends StatelessWidget {
  const QuickDineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickDine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      // 첫 화면 = 검색 조건 입력 화면
      home: const SearchScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// Shop 모델: HotPepper API JSON 응답을 Dart 객체로 변환
// ─────────────────────────────────────────────
class Shop {
  final String name; // 점포 명칭
  final String access; // 접근성 (역·도보 정보)
  final String logoImage; // 썸네일(로고) 이미지 URL
  final String address; // 주소
  final String open; // 영업시간
  final String photoUrl; // 상세 사진 URL (photo.pc.l 에서 추출)

  Shop({
    required this.name,
    required this.access,
    required this.logoImage,
    required this.address,
    required this.open,
    required this.photoUrl,
  });

  /// JSON Map 하나(식당 1건)를 Shop 객체로 변환하는 팩토리 생성자
  factory Shop.fromJson(Map<String, dynamic> json) {
    // photo 필드는 중첩 구조: photo → pc → l(대형) / m(중형) / s(소형)
    String photoUrl = '';
    final photo = json['photo'];
    if (photo is Map<String, dynamic>) {
      final pc = photo['pc'];
      if (pc is Map<String, dynamic>) {
        photoUrl = (pc['l'] ?? pc['m'] ?? pc['s'] ?? '') as String;
      }
    }

    return Shop(
      name: json['name'] as String? ?? '이름 없음',
      access: json['access'] as String? ?? '접근 정보 없음',
      logoImage: json['logo_image'] as String? ?? '',
      address: json['address'] as String? ?? '주소 정보 없음',
      open: json['open'] as String? ?? '영업시간 정보 없음',
      photoUrl: photoUrl,
    );
  }
}

// ─────────────────────────────────────────────
// GPS: 기기의 현재 위도·경도를 가져오는 함수
// ─────────────────────────────────────────────
Future<Position> getCurrentPosition() async {
  // 1) 기기의 위치 서비스(GPS)가 켜져 있는지 확인
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('위치 서비스가 꺼져 있습니다. 설정에서 GPS를 켜 주세요.');
  }

  // 2) 위치 권한 상태 확인 후, 없으면 사용자에게 요청
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied) {
    throw Exception('위치 권한이 거부되었습니다.');
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception('위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 허용해 주세요.');
  }

  // 3) 현재 GPS 좌표 반환 (위도 lat, 경도 lng)
  return Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );
}

// ─────────────────────────────────────────────
// API: HotPepper Gourmet Search API를 호출해 주변 식당 목록 반환
//   lat, lng : 검색 기준 좌표
//   range    : API 검색 반경 코드 (1=300m, 2=500m, 3=1000m, 4=2000m, 5=3000m)
// ─────────────────────────────────────────────
Future<List<Shop>> searchShops({
  required double lat,
  required double lng,
  required int range,
}) async {
  // 쿼리 파라미터를 붙인 URL 생성
  final uri = Uri.parse(kApiBaseUrl).replace(
    queryParameters: {
      'key': kApiKey,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'range': range.toString(),
      'format': 'json',
      'count': '20', // 첫 페이지만 (최대 20건)
    },
  );

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('API 오류: HTTP ${response.statusCode}');
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  final results = data['results'] as Map<String, dynamic>?;

  if (results == null) {
    throw Exception('API 응답 형식이 올바르지 않습니다.');
  }

  // 검색 결과가 0건이면 빈 리스트 반환
  final available = int.tryParse('${results['results_available']}') ?? 0;
  if (available == 0) {
    return [];
  }

  // shop 필드는 배열이거나 단일 객체일 수 있음 → 항상 리스트로 통일
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

// ═══════════════════════════════════════════════
// 화면 1: 검색 조건 입력 화면 (Search Screen)
// ═══════════════════════════════════════════════
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 검색 반경 선택지: 표시 라벨과 API range 코드를 쌍으로 관리
  static const List<Map<String, dynamic>> _radiusOptions = [
    {'label': '300m', 'range': 1},
    {'label': '500m', 'range': 2},
    {'label': '1000m', 'range': 3},
    {'label': '2000m', 'range': 4},
    {'label': '3000m', 'range': 5},
  ];

  int _selectedRange = 3; // 기본값: 1000m (range=3)
  bool _isLoading = false;
  String? _locationText; // GPS로 얻은 좌표를 화면에 표시

  /// '검색' 버튼을 눌렀을 때 실행되는 핵심 로직
  /// ① GPS로 좌표 취득 → ② API 호출 → ③ 결과 화면으로 이동
  Future<void> _onSearchPressed() async {
    setState(() {
      _isLoading = true;
      _locationText = null;
    });

    try {
      // ① 현재 위치(GPS) 가져오기
      final position = await getCurrentPosition();
      setState(() {
        _locationText =
            '위도: ${position.latitude.toStringAsFixed(5)}, '
            '경도: ${position.longitude.toStringAsFixed(5)}';
      });

      // ② HotPepper API로 주변 식당 검색
      final shops = await searchShops(
        lat: position.latitude,
        lng: position.longitude,
        range: _selectedRange,
      );

      if (!mounted) return;

      // ③ 검색 결과 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ListScreen(shops: shops),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickDine - 주변 맛집 검색'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '현재 위치 기준으로 주변 레스토랑을 검색합니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // 검색 반경 선택 드롭다운
            const Text('검색 반경', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedRange,
                  items: _radiusOptions.map((option) {
                    return DropdownMenuItem<int>(
                      value: option['range'] as int,
                      child: Text(option['label'] as String),
                    );
                  }).toList(),
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _selectedRange = value);
                          }
                        },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // GPS로 취득한 좌표 표시 영역
            if (_locationText != null) ...[
              Text(_locationText!, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
            ],

            const Spacer(),

            // 검색 버튼
            FilledButton.icon(
              onPressed: _isLoading ? null : _onSearchPressed,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(_isLoading ? '검색 중...' : '검색'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// 화면 2: 검색 결과 목록 화면 (List Screen)
// ═══════════════════════════════════════════════
class ListScreen extends StatelessWidget {
  final List<Shop> shops;

  const ListScreen({super.key, required this.shops});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색 결과 (${shops.length}건)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: shops.isEmpty
          // 결과가 없을 때 안내 메시지
          ? const Center(
              child: Text(
                '주변에 검색된 레스토랑이 없습니다.\n반경을 넓혀 다시 검색해 보세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          // 결과 리스트: name, access, logo_image 표시
          : ListView.separated(
              itemCount: shops.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final shop = shops[index];
                return ListTile(
                  // 썸네일 이미지 (logo_image)
                  leading: shop.logoImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            shop.logoImage,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.restaurant, size: 40),
                          ),
                        )
                      : const Icon(Icons.restaurant, size: 40),
                  // 점포 명칭 (name)
                  title: Text(
                    shop.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // 접근성 (access)
                  subtitle: Text(shop.access),
                  trailing: const Icon(Icons.chevron_right),
                  // 탭하면 상세 화면으로 이동
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(shop: shop),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// ═══════════════════════════════════════════════
// 화면 3: 점포 상세 화면 (Detail Screen)
// ═══════════════════════════════════════════════
class DetailScreen extends StatelessWidget {
  final Shop shop;

  const DetailScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('점포 상세'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상세 이미지 (photo)
            if (shop.photoUrl.isNotEmpty)
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
              )
            else
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
                  // 점포 명칭 (name)
                  Text(
                    shop.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // 주소 (address)
                  _DetailRow(
                    icon: Icons.location_on,
                    label: '주소',
                    value: shop.address,
                  ),
                  const SizedBox(height: 12),

                  // 영업시간 (open)
                  _DetailRow(
                    icon: Icons.access_time,
                    label: '영업시간',
                    value: shop.open,
                  ),
                  const SizedBox(height: 12),

                  // 접근성 (참고용 추가 표시)
                  _DetailRow(
                    icon: Icons.directions_walk,
                    label: '접근',
                    value: shop.access,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 상세 화면에서 라벨+값을 아이콘과 함께 보여주는 작은 위젯
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
