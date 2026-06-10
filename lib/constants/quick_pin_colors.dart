import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 퀵핀 색상 색인 — 리스트·지도 마커에서 동일 index 사용
class QuickPinColors {
  QuickPinColors._();

  static const List<Color> listColors = [
    Color(0xFF1976D2),
    Color(0xFF388E3C),
    Color(0xFFF57C00),
    Color(0xFF7B1FA2),
    Color(0xFFC2185B),
    Color(0xFF0097A7),
    Color(0xFF689F38),
    Color(0xFF5D4037),
  ];

  static const List<double> markerHues = [
    BitmapDescriptor.hueAzure,
    BitmapDescriptor.hueGreen,
    BitmapDescriptor.hueOrange,
    BitmapDescriptor.hueViolet,
    BitmapDescriptor.hueRose,
    BitmapDescriptor.hueCyan,
    BitmapDescriptor.hueYellow,
    BitmapDescriptor.hueRed,
  ];

  static Color listColor(int index) => listColors[index % listColors.length];

  static double markerHue(int index) => markerHues[index % markerHues.length];
}
