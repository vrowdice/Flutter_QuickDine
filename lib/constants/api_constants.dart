/// HotPepper API 및 크레딧 관련 상수
class ApiConstants {
  ApiConstants._();

  static const String hotPepperApiBaseUrl =
      'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/';

  static const String hotPepperServiceUrl = 'http://webservice.recruit.co.jp/';

  /// API 키가 담긴 env 파일 경로 (pubspec.yaml assets에 등록 필요)
  static const String envAssetPath = 'assets/env';

  /// env 파일의 HotPepper API 키 변수명
  static const String envApiKeyName = 'HOTPEPPER_API_KEY';

  /// env 파일의 Google Maps API 키 변수명
  static const String envGoogleMapsApiKeyName = 'GOOGLE_MAPS_API_KEY';

  /// HotPepper API count 상한
  static const int maxResultCount = 100;

  /// 기본 검색 반경 range 코드 (500m) — 실제 값은 [search_radius.dart] 참고
  static const int defaultSearchApiRange = 2;

  /// HotPepper는 일본 데이터만 제공 → 기본 지도 중심을 도쿄역으로 설정
  static const double defaultMapLat = 35.681236;
  static const double defaultMapLng = 139.767125;
}
