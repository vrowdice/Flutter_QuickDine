import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'QuickDine'**
  String get appTitle;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'QuickDine - Nearby Restaurants'**
  String get searchTitle;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @mapTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to choose a search location, then tap Search.'**
  String get mapTapHint;

  /// No description provided for @searchCoords.
  ///
  /// In en, this message translates to:
  /// **'Search coords: {lat}, {lng}'**
  String searchCoords(String lat, String lng);

  /// No description provided for @searchRadius.
  ///
  /// In en, this message translates to:
  /// **'Search radius'**
  String get searchRadius;

  /// No description provided for @searchRadiusMeters.
  ///
  /// In en, this message translates to:
  /// **'{meters}m'**
  String searchRadiusMeters(int meters);

  /// No description provided for @searchMaxCount.
  ///
  /// In en, this message translates to:
  /// **'Max results'**
  String get searchMaxCount;

  /// No description provided for @searchCountOption.
  ///
  /// In en, this message translates to:
  /// **'{count} places'**
  String searchCountOption(int count);

  /// No description provided for @searchAtLocation.
  ///
  /// In en, this message translates to:
  /// **'Search here'**
  String get searchAtLocation;

  /// No description provided for @searchPill.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchPill;

  /// No description provided for @genreAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get genreAll;

  /// No description provided for @genreIzakaya.
  ///
  /// In en, this message translates to:
  /// **'Izakaya'**
  String get genreIzakaya;

  /// No description provided for @genreJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get genreJapanese;

  /// No description provided for @genreItalianFrench.
  ///
  /// In en, this message translates to:
  /// **'Italian/French'**
  String get genreItalianFrench;

  /// No description provided for @genreChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get genreChinese;

  /// No description provided for @genreYakiniku.
  ///
  /// In en, this message translates to:
  /// **'Yakiniku'**
  String get genreYakiniku;

  /// No description provided for @genreAsian.
  ///
  /// In en, this message translates to:
  /// **'Asian/Ethnic'**
  String get genreAsian;

  /// No description provided for @genreCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe/Dessert'**
  String get genreCafe;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorPrefix;

  /// No description provided for @movedToCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Moved map to current location.'**
  String get movedToCurrentLocation;

  /// No description provided for @locationErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Location error'**
  String get locationErrorPrefix;

  /// No description provided for @quickPin.
  ///
  /// In en, this message translates to:
  /// **'Quick Pin'**
  String get quickPin;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get searchLocation;

  /// No description provided for @quickPinAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Quick Pin'**
  String get quickPinAdd;

  /// No description provided for @placeName.
  ///
  /// In en, this message translates to:
  /// **'Place name'**
  String get placeName;

  /// No description provided for @placeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tokyo Station'**
  String get placeNameHint;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @quickPinSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved Quick Pin \"{name}\".'**
  String quickPinSaved(String name);

  /// No description provided for @quickPinDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Quick Pin'**
  String get quickPinDelete;

  /// No description provided for @quickPinDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete Quick Pin \"{name}\"?'**
  String quickPinDeleteConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @randomPick.
  ///
  /// In en, this message translates to:
  /// **'Pick for me'**
  String get randomPick;

  /// No description provided for @addCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Add current location'**
  String get addCurrentLocation;

  /// No description provided for @quickPinEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a location on the map,\nthen tap \"Add current location\".'**
  String get quickPinEmptyHint;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Results ({count})'**
  String searchResults(int count);

  /// No description provided for @listEmpty.
  ///
  /// In en, this message translates to:
  /// **'No restaurants found nearby.\nTry increasing the radius or max results.'**
  String get listEmpty;

  /// No description provided for @shopDetail.
  ///
  /// In en, this message translates to:
  /// **'Shop details'**
  String get shopDetail;

  /// No description provided for @showOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get showOnMap;

  /// No description provided for @shopLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This shop has no location data.'**
  String get shopLocationUnavailable;

  /// No description provided for @showedShopOnMap.
  ///
  /// In en, this message translates to:
  /// **'Showing \"{name}\" on the map.'**
  String showedShopOnMap(String name);

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @businessHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get businessHours;

  /// No description provided for @access.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get access;

  /// No description provided for @detailCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get detailCall;

  /// No description provided for @filterParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get filterParking;

  /// No description provided for @filterPrivateRoom.
  ///
  /// In en, this message translates to:
  /// **'Private room'**
  String get filterPrivateRoom;

  /// No description provided for @detailWeb.
  ///
  /// In en, this message translates to:
  /// **'Details / Reserve'**
  String get detailWeb;

  /// No description provided for @averageBudget.
  ///
  /// In en, this message translates to:
  /// **'Average budget'**
  String get averageBudget;

  /// No description provided for @launchPhoneFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone app.'**
  String get launchPhoneFailed;

  /// No description provided for @launchWebFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the shop page.'**
  String get launchWebFailed;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorite restaurants yet.\nTap ♥ on results or details to add one.'**
  String get favoritesEmpty;

  /// No description provided for @addFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addFavorite;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFavorite;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get sectionSearch;

  /// No description provided for @defaultMaxSearchCount.
  ///
  /// In en, this message translates to:
  /// **'Default max results'**
  String get defaultMaxSearchCount;

  /// No description provided for @defaultMaxSearchCountHint.
  ///
  /// In en, this message translates to:
  /// **'Max shops per API request and on-screen display. Caps load even at 3000m radius.'**
  String get defaultMaxSearchCountHint;

  /// No description provided for @defaultSearchRadius.
  ///
  /// In en, this message translates to:
  /// **'Default search radius'**
  String get defaultSearchRadius;

  /// No description provided for @defaultSearchRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'Default radius when opening the search screen.'**
  String get defaultSearchRadiusHint;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @clearAllFavorites.
  ///
  /// In en, this message translates to:
  /// **'Clear all favorites'**
  String get clearAllFavorites;

  /// No description provided for @clearAllFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove locally saved favorites'**
  String get clearAllFavoritesSubtitle;

  /// No description provided for @clearAllQuickPins.
  ///
  /// In en, this message translates to:
  /// **'Clear all Quick Pins'**
  String get clearAllQuickPins;

  /// No description provided for @clearAllQuickPinsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove locally saved Quick Pins'**
  String get clearAllQuickPinsSubtitle;

  /// No description provided for @confirmClearFavorites.
  ///
  /// In en, this message translates to:
  /// **'Clear all favorites'**
  String get confirmClearFavorites;

  /// No description provided for @confirmClearFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete all saved favorites?'**
  String get confirmClearFavoritesMessage;

  /// No description provided for @favoritesCleared.
  ///
  /// In en, this message translates to:
  /// **'All favorites deleted.'**
  String get favoritesCleared;

  /// No description provided for @confirmClearQuickPins.
  ///
  /// In en, this message translates to:
  /// **'Clear all Quick Pins'**
  String get confirmClearQuickPins;

  /// No description provided for @confirmClearQuickPinsMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete all saved Quick Pins?'**
  String get confirmClearQuickPinsMessage;

  /// No description provided for @quickPinsCleared.
  ///
  /// In en, this message translates to:
  /// **'All Quick Pins deleted.'**
  String get quickPinsCleared;

  /// No description provided for @sectionAppInfo.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAppInfo;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Nearby restaurant search using HotPepper API'**
  String get appDescription;

  /// No description provided for @dataProvider.
  ///
  /// In en, this message translates to:
  /// **'Data provider'**
  String get dataProvider;

  /// No description provided for @dataProviderValue.
  ///
  /// In en, this message translates to:
  /// **'Restaurant info: ホットペッパーグルメ Webサービス'**
  String get dataProviderValue;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please turn on GPS in settings.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Allow it in app settings.'**
  String get locationPermissionDeniedForever;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
