// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'QuickDine';

  @override
  String get searchTitle => 'QuickDine - 주변 맛집 검색';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get settings => '설정';

  @override
  String get mapTapHint => '지도를 탭해 검색 위치를 선택한 뒤 검색하세요.';

  @override
  String searchCoords(String lat, String lng) {
    return '검색 좌표: $lat, $lng';
  }

  @override
  String get searchRadius => '검색 반경';

  @override
  String searchRadiusMeters(int meters) {
    return '${meters}m';
  }

  @override
  String get searchMaxCount => '최대 검색 개수';

  @override
  String searchCountOption(int count) {
    return '$count곳';
  }

  @override
  String get searchAtLocation => '이 위치에서 검색';

  @override
  String get searchPill => '검색하기';

  @override
  String get searching => '검색 중...';

  @override
  String get errorPrefix => '오류';

  @override
  String get movedToCurrentLocation => '현재 위치로 지도를 이동했습니다.';

  @override
  String get locationErrorPrefix => '위치 오류';

  @override
  String get quickPin => '퀵핀';

  @override
  String get searchLocation => '검색 위치';

  @override
  String get quickPinAdd => '퀵핀 추가';

  @override
  String get placeName => '장소 이름';

  @override
  String get placeNameHint => '예: 도쿄역';

  @override
  String get latitude => '위도';

  @override
  String get longitude => '경도';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String quickPinSaved(String name) {
    return '「$name」 퀵핀을 저장했습니다.';
  }

  @override
  String get quickPinDelete => '퀵핀 삭제';

  @override
  String quickPinDeleteConfirm(String name) {
    return '「$name」 퀵핀을 삭제할까요?';
  }

  @override
  String get delete => '삭제';

  @override
  String get close => '닫기';

  @override
  String get addCurrentLocation => '현재 위치 추가';

  @override
  String get quickPinEmptyHint => '지도에서 위치를 고른 뒤\n「현재 위치 추가」로\n저장하세요.';

  @override
  String searchResults(int count) {
    return '검색 결과 ($count건)';
  }

  @override
  String get listEmpty => '주변에 검색된 레스토랑이 없습니다.\n반경 또는 최대 개수를 늘려 다시 검색해 보세요.';

  @override
  String get shopDetail => '점포 상세';

  @override
  String get showOnMap => '지도에서 보기';

  @override
  String get shopLocationUnavailable => '이 점포의 위치 정보가 없습니다.';

  @override
  String showedShopOnMap(String name) {
    return '「$name」 위치를 지도에 표시했습니다.';
  }

  @override
  String get address => '주소';

  @override
  String get businessHours => '영업시간';

  @override
  String get access => '접근';

  @override
  String get favoritesEmpty => '즐겨찾기한 식당이 없습니다.\n검색 결과나 상세 화면에서 ♥ 를 눌러 추가하세요.';

  @override
  String get addFavorite => '즐겨찾기 추가';

  @override
  String get removeFavorite => '즐겨찾기 해제';

  @override
  String get settingsTitle => '설정';

  @override
  String get sectionSearch => '검색';

  @override
  String get defaultMaxSearchCount => '기본 최대 검색 개수';

  @override
  String get defaultMaxSearchCountHint =>
      '한 번에 API에 요청·표시할 최대 점포 수입니다. 3000m처럼 넓은 반경에서도 이 개수로 제한됩니다.';

  @override
  String get defaultSearchRadius => '기본 검색 반경';

  @override
  String get defaultSearchRadiusHint => '검색 화면을 열 때 적용되는 기본 반경입니다.';

  @override
  String get sectionLanguage => '언어';

  @override
  String get language => '앱 언어';

  @override
  String get languageSystem => '시스템 기본값';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get sectionData => '데이터';

  @override
  String get clearAllFavorites => '즐겨찾기 전체 삭제';

  @override
  String get clearAllFavoritesSubtitle => '로컬에 저장된 즐겨찾기를 지웁니다';

  @override
  String get clearAllQuickPins => '퀵핀 전체 삭제';

  @override
  String get clearAllQuickPinsSubtitle => '로컬에 저장된 퀵핀을 지웁니다';

  @override
  String get confirmClearFavorites => '즐겨찾기 전체 삭제';

  @override
  String get confirmClearFavoritesMessage => '저장된 모든 즐겨찾기를 삭제할까요?';

  @override
  String get favoritesCleared => '즐겨찾기를 모두 삭제했습니다.';

  @override
  String get confirmClearQuickPins => '퀵핀 전체 삭제';

  @override
  String get confirmClearQuickPinsMessage => '저장된 모든 퀵핀을 삭제할까요?';

  @override
  String get quickPinsCleared => '퀵핀을 모두 삭제했습니다.';

  @override
  String get sectionAppInfo => '앱 정보';

  @override
  String get appDescription => 'HotPepper API 기반 주변 맛집 검색 앱';

  @override
  String get dataProvider => '데이터 제공';

  @override
  String get dataProviderValue => '레스토랑 정보: ホットペッパーグルメ Webサービス';

  @override
  String get locationServiceDisabled => '위치 서비스가 꺼져 있습니다. 설정에서 GPS를 켜 주세요.';

  @override
  String get locationPermissionDenied => '위치 권한이 거부되었습니다.';

  @override
  String get locationPermissionDeniedForever =>
      '위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 허용해 주세요.';
}
