// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'QuickDine';

  @override
  String get searchTitle => 'QuickDine - 近くのお店検索';

  @override
  String get favorites => 'お気に入り';

  @override
  String get settings => '設定';

  @override
  String get mapTapHint => '地図をタップして検索位置を選び、検索ボタンを押してください。';

  @override
  String searchCoords(String lat, String lng) {
    return '検索座標: $lat, $lng';
  }

  @override
  String get searchRadius => '検索半径';

  @override
  String searchRadiusMeters(int meters) {
    return '${meters}m';
  }

  @override
  String get searchMaxCount => '最大取得件数';

  @override
  String searchCountOption(int count) {
    return '$count件';
  }

  @override
  String get searchAtLocation => 'この位置で検索';

  @override
  String get searchPill => '検索する';

  @override
  String get genreAll => 'すべて';

  @override
  String get genreIzakaya => '居酒屋';

  @override
  String get genreJapanese => '和食';

  @override
  String get genreItalianFrench => 'イタリアン・フレンチ';

  @override
  String get genreChinese => '中華';

  @override
  String get genreYakiniku => '焼肉';

  @override
  String get genreAsian => 'アジア・エスニック';

  @override
  String get genreCafe => 'カフェ・スイーツ';

  @override
  String get searching => '検索中...';

  @override
  String get errorPrefix => 'エラー';

  @override
  String get movedToCurrentLocation => '現在地に地図を移動しました。';

  @override
  String get locationErrorPrefix => '位置情報エラー';

  @override
  String get quickPin => 'クイックピン';

  @override
  String get searchLocation => '検索位置';

  @override
  String get quickPinAdd => 'クイックピン追加';

  @override
  String get placeName => '場所名';

  @override
  String get placeNameHint => '例: 東京駅';

  @override
  String get latitude => '緯度';

  @override
  String get longitude => '経度';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String quickPinSaved(String name) {
    return '「$name」クイックピンを保存しました。';
  }

  @override
  String get quickPinDelete => 'クイックピン削除';

  @override
  String quickPinDeleteConfirm(String name) {
    return '「$name」クイックピンを削除しますか？';
  }

  @override
  String get delete => '削除';

  @override
  String get close => '閉じる';

  @override
  String get addCurrentLocation => '現在地を追加';

  @override
  String get quickPinEmptyHint => '地図で位置を選び、\n「現在地を追加」で\n保存してください。';

  @override
  String searchResults(int count) {
    return '検索結果 ($count件)';
  }

  @override
  String get listEmpty => '近くに店舗が見つかりませんでした。\n半径または最大件数を増やして再検索してください。';

  @override
  String get shopDetail => '店舗詳細';

  @override
  String get showOnMap => '地図で表示';

  @override
  String get shopLocationUnavailable => 'この店舗の位置情報がありません。';

  @override
  String showedShopOnMap(String name) {
    return '「$name」の位置を地図に表示しました。';
  }

  @override
  String get address => '住所';

  @override
  String get businessHours => '営業時間';

  @override
  String get access => 'アクセス';

  @override
  String get detailCall => '電話する';

  @override
  String get detailWeb => '詳細/予約';

  @override
  String get averageBudget => '平均予算';

  @override
  String get launchPhoneFailed => '電話アプリを開けませんでした。';

  @override
  String get launchWebFailed => '店舗ページを開けませんでした。';

  @override
  String get favoritesEmpty => 'お気に入りの店舗がありません。\n検索結果や詳細画面で ♥ を押して追加してください。';

  @override
  String get addFavorite => 'お気に入りに追加';

  @override
  String get removeFavorite => 'お気に入り解除';

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionSearch => '検索';

  @override
  String get defaultMaxSearchCount => 'デフォルト最大件数';

  @override
  String get defaultMaxSearchCountHint =>
      '1回のAPIリクエスト・表示件数の上限です。3000mなど広い半径でもこの件数に制限されます。';

  @override
  String get defaultSearchRadius => 'デフォルト検索半径';

  @override
  String get defaultSearchRadiusHint => '検索画面を開いたときに適用されるデフォルト半径です。';

  @override
  String get sectionLanguage => '言語';

  @override
  String get language => 'アプリの言語';

  @override
  String get languageSystem => 'システム設定に従う';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get sectionData => 'データ';

  @override
  String get clearAllFavorites => 'お気に入りをすべて削除';

  @override
  String get clearAllFavoritesSubtitle => '端末に保存されたお気に入りを削除';

  @override
  String get clearAllQuickPins => 'クイックピンをすべて削除';

  @override
  String get clearAllQuickPinsSubtitle => '端末に保存されたクイックピンを削除';

  @override
  String get confirmClearFavorites => 'お気に入りをすべて削除';

  @override
  String get confirmClearFavoritesMessage => '保存されたお気に入りをすべて削除しますか？';

  @override
  String get favoritesCleared => 'お気に入りをすべて削除しました。';

  @override
  String get confirmClearQuickPins => 'クイックピンをすべて削除';

  @override
  String get confirmClearQuickPinsMessage => '保存されたクイックピンをすべて削除しますか？';

  @override
  String get quickPinsCleared => 'クイックピンをすべて削除しました。';

  @override
  String get sectionAppInfo => 'アプリ情報';

  @override
  String get appDescription => 'HotPepper API を使った近くのお店検索アプリ';

  @override
  String get dataProvider => 'データ提供';

  @override
  String get dataProviderValue => '店舗情報: ホットペッパーグルメ Webサービス';

  @override
  String get developedBy => 'Developed by';

  @override
  String get locationServiceDisabled => '位置情報サービスがオフです。設定でGPSをオンにしてください。';

  @override
  String get locationPermissionDenied => '位置情報の権限が拒否されました。';

  @override
  String get locationPermissionDeniedForever =>
      '位置情報の権限が永久に拒否されました。アプリ設定で許可してください。';
}
