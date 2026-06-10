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
