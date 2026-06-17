import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// 확인/취소 다이얼로그 — true면 확인(삭제) 선택
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  return result == true;
}

/// 확인 후 작업 실행 → 성공 스낵바 표시
Future<void> clearWithConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required Future<void> Function() onClear,
  required String successMessage,
}) async {
  final ok = await showConfirmDialog(
    context,
    title: title,
    message: message,
  );
  if (!ok || !context.mounted) return;

  await onClear();
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(successMessage)),
  );
}
