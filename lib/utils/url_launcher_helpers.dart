import 'package:url_launcher/url_launcher.dart';

/// `tel:` 스킴으로 전화 앱 실행
Future<bool> launchPhoneCall(String phone) async {
  final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  if (digits.isEmpty) return false;

  final uri = Uri(scheme: 'tel', path: digits);
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri);
}

/// 외부 브라우저에서 URL 열기
Future<bool> launchExternalWebUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return false;
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
