import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/api_constants.dart';

/// HotPepper 이용 안내 준수 — 화면 하단 크레딧 (표시 의무)
class HotPepperCreditBar extends StatelessWidget {
  const HotPepperCreditBar({super.key});

  Future<void> _openServicePage() async {
    final uri = Uri.parse(ApiConstants.hotPepperServiceUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('크레딧 링크를 열 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Powered by ',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              InkWell(
                onTap: _openServicePage,
                child: const Text(
                  'ホットペッパーグルメ Webサービス',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
