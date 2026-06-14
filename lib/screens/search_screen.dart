import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/api_constants.dart';
import '../constants/search_count.dart';
import '../constants/search_radius.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_pin.dart';
import '../models/shop.dart';
import '../services/hotpepper_api.dart';
import '../services/location_service.dart';
import '../services/settings_service.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/app_logo.dart';
import '../widgets/hot_pepper_credit_bar.dart';
import '../widgets/map_location_picker.dart';
import '../widgets/search_floating_controls.dart';
import '../widgets/search_map_stack.dart';
import '../widgets/search_pill_button.dart';
import '../widgets/search_results_sheet.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

/// 검색 화면 — 전체 화면 지도 허브 + 상단 플로팅 검색 + 하단 결과 시트
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _locationService = LocationService();
  final _hotPepperApi = HotPepperApi();
  final _mapKey = GlobalKey<MapLocationPickerState>();

  int _selectedMaxCount = kDefaultSearchCount;
  int _selectedRadius = kDefaultSearchRadius;
  bool _isLoading = false;
  bool _isQuickPinPanelOpen = false;
  bool _isSheetVisible = false;
  double _sheetExtent = SearchResultsSheet.initialChildSize;
  String? _selectedPinId;
  String? _selectedGenreCode;
  bool _filterParking = false;
  bool _filterPrivateRoom = false;

  double _searchLat = ApiConstants.defaultMapLat;
  double _searchLng = ApiConstants.defaultMapLng;

  List<Shop> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _selectedMaxCount = SettingsService.instance.defaultMaxSearchCount;
    _selectedRadius = SettingsService.instance.defaultSearchRadius;
    SettingsService.instance.addListener(_onSettingsChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyCurrentLocation(showFeedback: false);
    });
  }

  @override
  void dispose() {
    SettingsService.instance.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {
      _selectedMaxCount = SettingsService.instance.defaultMaxSearchCount;
      _selectedRadius = SettingsService.instance.defaultSearchRadius;
    });
  }

  void _clearSearchResults() {
    _searchResults = [];
    _isSheetVisible = false;
  }

  void _dismissResultsSheet() => setState(() => _isSheetVisible = false);

  Future<void> _onSearchPressed() async {
    // 결과가 있고 시트만 닫힌 상태면 재검색 없이 시트만 다시 표시
    if (_searchResults.isNotEmpty && !_isSheetVisible) {
      setState(() {
        _isSheetVisible = true;
        _sheetExtent = SearchResultsSheet.initialChildSize;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final shops = await _hotPepperApi.searchShops(
        lat: _searchLat,
        lng: _searchLng,
        count: _selectedMaxCount,
        range: _selectedRadius,
        genre: _selectedGenreCode,
        parking: _filterParking,
        privateRoom: _filterPrivateRoom,
      );

      if (!mounted) return;

      if (shops.isEmpty) {
        setState(_clearSearchResults);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.listEmpty)),
        );
        return;
      }

      setState(() {
        _searchResults = shops;
        _isSheetVisible = true;
        _sheetExtent = SearchResultsSheet.initialChildSize;
      });
      await _mapKey.currentState?.fitToSearchResults();
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.errorPrefix}: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _applyCurrentLocation({required bool showFeedback}) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final position = await _locationService.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        _searchLat = position.latitude;
        _searchLng = position.longitude;
        _selectedPinId = null;
        _clearSearchResults();
      });

      await _mapKey.currentState?.moveTo(
        position.latitude,
        position.longitude,
      );
      await _mapKey.currentState?.refreshMyLocationLayer();

      if (showFeedback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.movedToCurrentLocation)),
        );
      }
    } catch (e) {
      if (showFeedback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.locationErrorPrefix}: ${locationErrorMessage(l10n, e)}',
            ),
          ),
        );
      }
    }
  }

  Future<void> _moveToCurrentLocation() =>
      _applyCurrentLocation(showFeedback: true);

  void _onLocationChanged(LatLng position, {QuickPin? quickPin}) {
    setState(() {
      _searchLat = position.latitude;
      _searchLng = position.longitude;
      _selectedPinId = quickPin?.id;
      _clearSearchResults();
    });
  }

  Future<void> _showShopOnMap(Shop shop) async {
    if (!shop.hasLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.shopLocationUnavailable),
        ),
      );
      return;
    }

    setState(() {
      _searchLat = shop.lat!;
      _searchLng = shop.lng!;
      _selectedPinId = null;
      if (!_searchResults.any((s) => s.favoriteKey == shop.favoriteKey)) {
        _searchResults = [..._searchResults, shop];
      }
      _isSheetVisible = _searchResults.isNotEmpty;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.showedShopOnMap(shop.name),
          ),
        ),
      );
    }
  }

  Future<void> _openShopDetail(Shop shop) async {
    final result = await Navigator.push<Shop>(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(shop: shop)),
    );
    if (result != null && mounted) {
      await _showShopOnMap(result);
    }
  }

  Future<void> _openFavorites() async {
    final result = await Navigator.push<Shop>(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
    if (result != null && mounted) {
      await _showShopOnMap(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topInset = SearchFloatingControls.estimatedHeight;
    final sheetVisible =
        _searchResults.isNotEmpty && _isSheetVisible && !_isQuickPinPanelOpen;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Center(child: AppLogo(size: 26)),
        ),
        leadingWidth: 44,
        title: Text(l10n.searchTitle),
        actions: [
          IconButton(
            onPressed: _openFavorites,
            tooltip: l10n.favorites,
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // DraggableScrollableSheet는 body(Stack) 높이 기준 — 전체 화면 높이와 다름
          final stackHeight = constraints.maxHeight;
          final sheetTop = _sheetExtent * stackHeight;
          final mapBottomPadding = sheetVisible ? sheetTop : 0.0;
          const creditBarInset = 44.0;
          final panelBottomInset =
              (sheetVisible ? sheetTop : creditBarInset) + 8;
          final searchPillBottom = (sheetVisible ? sheetTop : creditBarInset) +
              SearchPillButton.verticalMargin;

          return Stack(
            fit: StackFit.expand,
            children: [
              SearchMapStack(
                mapKey: _mapKey,
                searchLat: _searchLat,
                searchLng: _searchLng,
                isLoading: _isLoading,
                isPanelOpen: _isQuickPinPanelOpen,
                selectedPinId: _selectedPinId,
                shops: _searchResults,
                topOverlayInset: topInset,
                mapBottomPadding: mapBottomPadding,
                panelBottomInset: panelBottomInset,
                searchRadiusRange: _selectedRadius,
                onLocationChanged: _onLocationChanged,
                onShopTap: _openShopDetail,
                onPanelOpen: () => setState(() => _isQuickPinPanelOpen = true),
                onPanelClose: () => setState(() => _isQuickPinPanelOpen = false),
                onCurrentLocation: _moveToCurrentLocation,
                onPinSelected: (pin) => _mapKey.currentState?.moveTo(
                  pin.lat,
                  pin.lng,
                  quickPin: pin,
                ),
              ),
              if (sheetVisible)
                SearchResultsSheet(
                  key: ValueKey(_searchResults.length),
                  shops: _searchResults,
                  onShopTap: _openShopDetail,
                  onDismissed: _dismissResultsSheet,
                  onExtentChanged: (extent) {
                    if (_sheetExtent != extent) {
                      setState(() => _sheetExtent = extent);
                    }
                  },
                ),
              if (!sheetVisible)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: HotPepperCreditBar(),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SearchFloatingControls(
                  selectedRadius: _selectedRadius,
                  selectedMaxCount: _selectedMaxCount,
                  selectedGenreCode: _selectedGenreCode,
                  filterParking: _filterParking,
                  filterPrivateRoom: _filterPrivateRoom,
                  isLoading: _isLoading,
                  onRadiusChanged: _isLoading
                      ? null
                      : (range) => setState(
                            () => _selectedRadius = clampSearchRadius(range),
                          ),
                  onMaxCountChanged: _isLoading
                      ? null
                      : (count) => setState(
                            () => _selectedMaxCount = clampSearchCount(count),
                          ),
                  onGenreChanged: _isLoading
                      ? null
                      : (code) => setState(() {
                            _selectedGenreCode = code;
                            _clearSearchResults();
                          }),
                  onFilterParkingChanged: _isLoading
                      ? null
                      : (value) => setState(() {
                            _filterParking = value;
                            _clearSearchResults();
                          }),
                  onFilterPrivateRoomChanged: _isLoading
                      ? null
                      : (value) => setState(() {
                            _filterPrivateRoom = value;
                            _clearSearchResults();
                          }),
                ),
              ),
              if (!_isQuickPinPanelOpen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: searchPillBottom,
                  child: Center(
                    child: SearchPillButton(
                      isLoading: _isLoading,
                      onPressed: _onSearchPressed,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
