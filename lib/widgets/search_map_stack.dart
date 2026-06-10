import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../l10n/app_localizations.dart';
import '../models/quick_pin.dart';
import '../models/shop.dart';
import '../services/quick_pin_service.dart';
import 'map_location_picker.dart';
import 'quick_pin_panel.dart';
import 'search_floating_controls.dart';

/// 전체 화면 지도 + 퀵핀·내 위치 오버레이 (검색 결과 시트는 [SearchScreen]에서 관리)
class SearchMapStack extends StatelessWidget {
  final GlobalKey<MapLocationPickerState> mapKey;
  final double searchLat;
  final double searchLng;
  final bool isLoading;
  final bool isPanelOpen;
  final String? selectedPinId;
  final List<Shop> shops;
  final double topOverlayInset;
  final double mapBottomPadding;
  final double panelBottomInset;
  final int searchRadiusRange;
  final void Function(LatLng position, {QuickPin? quickPin}) onLocationChanged;
  final ValueChanged<Shop> onShopTap;
  final VoidCallback onPanelOpen;
  final VoidCallback onPanelClose;
  final VoidCallback onCurrentLocation;
  final ValueChanged<QuickPin> onPinSelected;

  const SearchMapStack({
    super.key,
    required this.mapKey,
    required this.searchLat,
    required this.searchLng,
    required this.isLoading,
    required this.isPanelOpen,
    required this.selectedPinId,
    required this.shops,
    required this.topOverlayInset,
    required this.mapBottomPadding,
    required this.panelBottomInset,
    required this.searchRadiusRange,
    required this.onLocationChanged,
    required this.onShopTap,
    required this.onPanelOpen,
    required this.onPanelClose,
    required this.onCurrentLocation,
    required this.onPinSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quickPinTop =
        topOverlayInset + SearchFloatingControls.quickPinGapBelowBar;
    final mapControlInset = SearchFloatingControls.horizontalMargin;

    return ListenableBuilder(
      listenable: QuickPinService.instance,
      builder: (context, _) {
        final pins = QuickPinService.instance.pins;

        return Stack(
          fit: StackFit.expand,
          children: [
            MapLocationPicker(
              key: mapKey,
              initialLat: searchLat,
              initialLng: searchLng,
              quickPins: pins,
              shops: shops,
              topPadding: topOverlayInset,
              bottomPadding: mapBottomPadding,
              searchRadiusRange: searchRadiusRange,
              onLocationChanged: onLocationChanged,
              onShopTap: onShopTap,
            ),
            if (isPanelOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: onPanelClose,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ),
              ),
            Positioned(
              top: quickPinTop,
              left: mapControlInset,
              bottom: panelBottomInset,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                offset: isPanelOpen ? Offset.zero : const Offset(-1.2, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isPanelOpen ? 1 : 0,
                  child: IgnorePointer(
                    ignoring: !isPanelOpen,
                    child: QuickPinPanel(
                      pins: pins,
                      currentLat: searchLat,
                      currentLng: searchLng,
                      enabled: !isLoading,
                      selectedPinId: selectedPinId,
                      onClose: onPanelClose,
                      onPinSelected: onPinSelected,
                    ),
                  ),
                ),
              ),
            ),
            if (!isPanelOpen)
              Positioned(
                top: quickPinTop,
                left: mapControlInset,
                child: _BouncyMapOverlayButton(
                  onTap: isLoading ? null : onPanelOpen,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.push_pin,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.quickPin,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      if (pins.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.orange,
                          child: Text(
                            '${pins.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            Positioned(
              top: quickPinTop,
              right: mapControlInset,
              child: _MapOverlayButton(
                onTap: isLoading ? null : onCurrentLocation,
                child: Icon(
                  Icons.my_location,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MapOverlayButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _MapOverlayButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}

/// 퀵핀 버튼 — 탭 시 스케일 바운스 피드백
class _BouncyMapOverlayButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _BouncyMapOverlayButton({required this.onTap, required this.child});

  @override
  State<_BouncyMapOverlayButton> createState() =>
      _BouncyMapOverlayButtonState();
}

class _BouncyMapOverlayButtonState extends State<_BouncyMapOverlayButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTap?.call();
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: Duration(milliseconds: _pressed ? 80 : 280),
        curve: _pressed ? Curves.easeOutCubic : Curves.elasticOut,
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
