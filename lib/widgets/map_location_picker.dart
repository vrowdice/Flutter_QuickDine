import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/quick_pin_colors.dart';
import '../constants/search_radius.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_pin.dart';
import '../models/shop.dart';

/// Google Map — 검색 중심, 퀵핀, 검색 결과 식당 표시
class MapLocationPicker extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final List<QuickPin> quickPins;
  final List<Shop> shops;
  final double topPadding;
  final double bottomPadding;
  final int searchRadiusRange;
  final void Function(LatLng position, {QuickPin? quickPin}) onLocationChanged;
  final ValueChanged<Shop>? onShopTap;

  const MapLocationPicker({
    super.key,
    required this.initialLat,
    required this.initialLng,
    this.quickPins = const [],
    this.shops = const [],
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.searchRadiusRange = kDefaultSearchRadius,
    required this.onLocationChanged,
    this.onShopTap,
  });

  @override
  State<MapLocationPicker> createState() => MapLocationPickerState();
}

class MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  late LatLng _selectedPosition;
  bool _myLocationEnabled = false;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  bool _overlaysDirty = true;

  @override
  void initState() {
    super.initState();
    _selectedPosition = LatLng(widget.initialLat, widget.initialLng);
    _syncMyLocationLayer();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> refreshMyLocationLayer() => _syncMyLocationLayer();

  Future<void> _syncMyLocationLayer() async {
    final permission = await Geolocator.checkPermission();
    if (!mounted) return;
    setState(() {
      _myLocationEnabled =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    });
  }

  @override
  void didUpdateWidget(MapLocationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialLat != widget.initialLat ||
        oldWidget.initialLng != widget.initialLng) {
      final target = LatLng(widget.initialLat, widget.initialLng);
      setState(() => _selectedPosition = target);
      _markOverlaysDirty();
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(target, 15),
      );
    } else if (oldWidget.quickPins != widget.quickPins ||
        oldWidget.shops != widget.shops ||
        oldWidget.searchRadiusRange != widget.searchRadiusRange) {
      _markOverlaysDirty();
    }
  }

  void _markOverlaysDirty() => _overlaysDirty = true;

  void _ensureOverlays(AppLocalizations l10n, Color primary) {
    if (!_overlaysDirty) return;
    _markers = _buildMarkers(l10n);
    _circles = _buildSearchRadiusCircle(primary);
    _overlaysDirty = false;
  }

  void _selectPosition(LatLng target, {QuickPin? quickPin}) {
    setState(() {
      _selectedPosition = target;
      _markOverlaysDirty();
    });
    widget.onLocationChanged(target, quickPin: quickPin);
  }

  Future<void> moveTo(double lat, double lng, {QuickPin? quickPin}) async {
    final target = LatLng(lat, lng);
    _selectPosition(target, quickPin: quickPin);
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(target, 15),
    );
  }

  /// 검색 중심 + 식당 마커가 보이도록 카메라 조정
  Future<void> fitToSearchResults() async {
    final controller = _mapController;
    if (controller == null || widget.shops.isEmpty) return;

    var minLat = _selectedPosition.latitude;
    var maxLat = minLat;
    var minLng = _selectedPosition.longitude;
    var maxLng = minLng;

    void expand(LatLng point) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    expand(_selectedPosition);

    for (final shop in widget.shops) {
      if (shop.hasLocation) {
        expand(LatLng(shop.lat!, shop.lng!));
      }
    }

    // 단일 좌표일 때 bounds 면적 0 방지
    const epsilon = 0.002;
    if ((maxLat - minLat).abs() < epsilon) {
      minLat -= epsilon;
      maxLat += epsilon;
    }
    if ((maxLng - minLng).abs() < epsilon) {
      minLng -= epsilon;
      maxLng += epsilon;
    }

    // GoogleMap.padding이 이미 top/bottom 여백을 반영함.
    // newLatLngBounds에 bottomPadding을 또 넣으면 가용 영역이 0에 가까워져
    // "View size is too small after padding" 오류가 발생한다.
    const boundsEdgePadding = 48.0;

    try {
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          boundsEdgePadding,
        ),
      );
    } catch (_) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedPosition, 14),
      );
    }
  }

  Set<Marker> _buildMarkers(AppLocalizations l10n) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('search_point'),
        position: _selectedPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: l10n.searchLocation),
      ),
    };

    for (var i = 0; i < widget.quickPins.length; i++) {
      final pin = widget.quickPins[i];
      markers.add(
        Marker(
          markerId: MarkerId('quick_pin_${pin.id}'),
          position: LatLng(pin.lat, pin.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            QuickPinColors.markerHue(i),
          ),
          infoWindow: InfoWindow(title: '${i + 1}. ${pin.name}'),
          onTap: () => _selectPosition(LatLng(pin.lat, pin.lng), quickPin: pin),
        ),
      );
    }

    for (final shop in widget.shops) {
      if (!shop.hasLocation) continue;
      markers.add(
        Marker(
          markerId: MarkerId(
            'shop_${shop.id.isNotEmpty ? shop.id : shop.favoriteKey}',
          ),
          position: LatLng(shop.lat!, shop.lng!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: shop.name, snippet: shop.access),
          onTap: () => widget.onShopTap?.call(shop),
        ),
      );
    }

    return markers;
  }

  /// 검색 중심을 기준으로 HotPepper range에 해당하는 반경 원 표시
  Set<Circle> _buildSearchRadiusCircle(Color primary) {
    final radiusMeters = searchRadiusMeters(widget.searchRadiusRange).toDouble();

    return {
      Circle(
        circleId: const CircleId('search_radius'),
        center: _selectedPosition,
        radius: radiusMeters,
        fillColor: primary.withValues(alpha: 0.12),
        strokeColor: primary.withValues(alpha: 0.55),
        strokeWidth: 2,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
    _ensureOverlays(l10n, primary);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedPosition,
          zoom: 14,
        ),
        padding: EdgeInsets.only(
          top: widget.topPadding,
          bottom: widget.bottomPadding,
        ),
        markers: _markers,
        circles: _circles,
        onMapCreated: (controller) => _mapController = controller,
        onTap: _selectPosition,
        myLocationEnabled: _myLocationEnabled,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
