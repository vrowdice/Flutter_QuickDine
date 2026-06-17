// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QuickDine';

  @override
  String get searchTitle => 'QuickDine - Nearby Restaurants';

  @override
  String get favorites => 'Favorites';

  @override
  String get settings => 'Settings';

  @override
  String get mapTapHint =>
      'Tap the map to choose a search location, then tap Search.';

  @override
  String searchCoords(String lat, String lng) {
    return 'Search coords: $lat, $lng';
  }

  @override
  String get searchRadius => 'Search radius';

  @override
  String searchRadiusMeters(int meters) {
    return '${meters}m';
  }

  @override
  String get searchMaxCount => 'Max results';

  @override
  String searchCountOption(int count) {
    return '$count places';
  }

  @override
  String get searchAtLocation => 'Search here';

  @override
  String get searchPill => 'Search';

  @override
  String get genreAll => 'All';

  @override
  String get genreIzakaya => 'Izakaya';

  @override
  String get genreJapanese => 'Japanese';

  @override
  String get genreItalianFrench => 'Italian/French';

  @override
  String get genreChinese => 'Chinese';

  @override
  String get genreYakiniku => 'Yakiniku';

  @override
  String get genreAsian => 'Asian/Ethnic';

  @override
  String get genreCafe => 'Cafe/Dessert';

  @override
  String get searching => 'Searching...';

  @override
  String get errorPrefix => 'Error';

  @override
  String get movedToCurrentLocation => 'Moved map to current location.';

  @override
  String get locationErrorPrefix => 'Location error';

  @override
  String get quickPin => 'Quick Pin';

  @override
  String get searchLocation => 'Search location';

  @override
  String get quickPinAdd => 'Add Quick Pin';

  @override
  String get placeName => 'Place name';

  @override
  String get placeNameHint => 'e.g. Tokyo Station';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String quickPinSaved(String name) {
    return 'Saved Quick Pin \"$name\".';
  }

  @override
  String get quickPinDelete => 'Delete Quick Pin';

  @override
  String quickPinDeleteConfirm(String name) {
    return 'Delete Quick Pin \"$name\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get randomPick => 'Pick for me';

  @override
  String get addCurrentLocation => 'Add current location';

  @override
  String get quickPinEmptyHint =>
      'Pick a location on the map,\nthen tap \"Add current location\".';

  @override
  String searchResults(int count) {
    return 'Results ($count)';
  }

  @override
  String get listEmpty =>
      'No restaurants found nearby.\nTry increasing the radius or max results.';

  @override
  String get shopDetail => 'Shop details';

  @override
  String get showOnMap => 'Show on map';

  @override
  String get shopLocationUnavailable => 'This shop has no location data.';

  @override
  String showedShopOnMap(String name) {
    return 'Showing \"$name\" on the map.';
  }

  @override
  String get address => 'Address';

  @override
  String get businessHours => 'Hours';

  @override
  String get access => 'Access';

  @override
  String get detailCall => 'Call';

  @override
  String get filterParking => 'Parking';

  @override
  String get filterPrivateRoom => 'Private room';

  @override
  String get detailWeb => 'Details / Reserve';

  @override
  String get averageBudget => 'Average budget';

  @override
  String get launchPhoneFailed => 'Could not open the phone app.';

  @override
  String get launchWebFailed => 'Could not open the shop page.';

  @override
  String get favoritesEmpty =>
      'No favorite restaurants yet.\nTap ♥ on results or details to add one.';

  @override
  String get addFavorite => 'Add to favorites';

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionSearch => 'Search';

  @override
  String get defaultMaxSearchCount => 'Default max results';

  @override
  String get defaultMaxSearchCountHint =>
      'Max shops per API request and on-screen display. Caps load even at 3000m radius.';

  @override
  String get defaultSearchRadius => 'Default search radius';

  @override
  String get defaultSearchRadiusHint =>
      'Default radius when opening the search screen.';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get language => 'App language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get languageEnglish => 'English';

  @override
  String get sectionData => 'Data';

  @override
  String get clearAllFavorites => 'Clear all favorites';

  @override
  String get clearAllFavoritesSubtitle => 'Remove locally saved favorites';

  @override
  String get clearAllQuickPins => 'Clear all Quick Pins';

  @override
  String get clearAllQuickPinsSubtitle => 'Remove locally saved Quick Pins';

  @override
  String get confirmClearFavorites => 'Clear all favorites';

  @override
  String get confirmClearFavoritesMessage => 'Delete all saved favorites?';

  @override
  String get favoritesCleared => 'All favorites deleted.';

  @override
  String get confirmClearQuickPins => 'Clear all Quick Pins';

  @override
  String get confirmClearQuickPinsMessage => 'Delete all saved Quick Pins?';

  @override
  String get quickPinsCleared => 'All Quick Pins deleted.';

  @override
  String get sectionAppInfo => 'About';

  @override
  String get appDescription => 'Nearby restaurant search using HotPepper API';

  @override
  String get dataProvider => 'Data provider';

  @override
  String get dataProviderValue => 'Restaurant info: ホットペッパーグルメ Webサービス';

  @override
  String get developedBy => 'Developed by';

  @override
  String get locationServiceDisabled =>
      'Location services are disabled. Please turn on GPS in settings.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission permanently denied. Allow it in app settings.';
}
