import 'package:flutter/material.dart';

/// 이미지 이용 시 필수 표기: 【画像提供：ホットペッパー グルメ】
class HotPepperImageCredit extends StatelessWidget {
  const HotPepperImageCredit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '【画像提供：ホットペッパー グルメ】',
        style: TextStyle(fontSize: 11, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
