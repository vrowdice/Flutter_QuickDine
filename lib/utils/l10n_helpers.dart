import '../l10n/app_localizations.dart';
import '../services/location_service.dart';

String locationErrorMessage(AppLocalizations l10n, Object error) {
  if (error is LocationException) {
    switch (error.code) {
      case LocationError.serviceDisabled:
        return l10n.locationServiceDisabled;
      case LocationError.permissionDenied:
        return l10n.locationPermissionDenied;
      case LocationError.permissionDeniedForever:
        return l10n.locationPermissionDeniedForever;
    }
  }
  return error.toString();
}

String genreLabel(AppLocalizations l10n, String? code) {
  switch (code) {
    case 'G001':
      return l10n.genreIzakaya;
    case 'G004':
      return l10n.genreJapanese;
    case 'G006':
      return l10n.genreItalianFrench;
    case 'G007':
      return l10n.genreChinese;
    case 'G008':
      return l10n.genreYakiniku;
    case 'G009':
      return l10n.genreAsian;
    case 'G014':
      return l10n.genreCafe;
    default:
      return l10n.genreAll;
  }
}

String facilityFilterLabel(AppLocalizations l10n, String apiParam) {
  switch (apiParam) {
    case 'parking':
      return l10n.filterParking;
    case 'private_room':
      return l10n.filterPrivateRoom;
    case 'wifi':
      return l10n.filterWifi;
    case 'card':
      return l10n.filterCard;
    case 'non_smoking':
      return l10n.filterNonSmoking;
    default:
      return apiParam;
  }
}

String languageLabel(AppLocalizations l10n, String code) {
  switch (code) {
    case 'ko':
      return l10n.languageKorean;
    case 'ja':
      return l10n.languageJapanese;
    case 'en':
      return l10n.languageEnglish;
    default:
      return l10n.languageSystem;
  }
}
