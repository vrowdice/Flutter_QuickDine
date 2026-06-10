import 'package:flutter/material.dart';

import 'hot_pepper_credit_bar.dart';

/// API 데이터를 보여주는 화면 하단에 크레딧을 붙이는 공통 레이아웃
class ScreenWithCredit extends StatelessWidget {
  final Widget child;

  const ScreenWithCredit({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const HotPepperCreditBar(),
      ],
    );
  }
}
