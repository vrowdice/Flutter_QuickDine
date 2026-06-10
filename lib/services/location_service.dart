import 'package:geolocator/geolocator.dart';

/// GPS 관련 오류 코드 (UI에서 l10n으로 변환)
enum LocationError {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class LocationException implements Exception {
  final LocationError code;

  LocationException(this.code);
}

/// GPS 관련 비즈니스 로직을 담당하는 서비스
class LocationService {
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException(LocationError.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw LocationException(LocationError.permissionDenied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationException(LocationError.permissionDeniedForever);
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
