import 'package:flutter/material.dart';

import '../constants/quick_pin_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_pin.dart';
import '../services/quick_pin_service.dart';
import '../utils/confirm_dialog.dart';

/// 지도 위 오버레이 퀵핀 패널 — 색상 색인 + 세로 ListView
class QuickPinPanel extends StatelessWidget {
  static const panelWidth = 140.0;

  final List<QuickPin> pins;
  final double currentLat;
  final double currentLng;
  final bool enabled;
  final String? selectedPinId;
  final VoidCallback onClose;
  final ValueChanged<QuickPin> onPinSelected;

  const QuickPinPanel({
    super.key,
    required this.pins,
    required this.currentLat,
    required this.currentLng,
    required this.enabled,
    required this.selectedPinId,
    required this.onClose,
    required this.onPinSelected,
  });

  Future<void> _showAddDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    try {
      final name = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.quickPinAdd),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.placeName,
                  hintText: l10n.placeNameHint,
                  border: const OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.pop(context, value.trim());
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                '${l10n.latitude}: ${currentLat.toStringAsFixed(5)}\n'
                '${l10n.longitude}: ${currentLng.toStringAsFixed(5)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) Navigator.pop(context, value);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      );

      if (name == null || name.isEmpty || !context.mounted) return;

      await QuickPinService.instance.add(
        name: name,
        lat: currentLat,
        lng: currentLng,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quickPinSaved(name))),
      );
    } finally {
      controller.dispose();
    }
  }

  Future<void> _confirmDelete(BuildContext context, QuickPin pin) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showConfirmDialog(
      context,
      title: l10n.quickPinDelete,
      message: l10n.quickPinDeleteConfirm(pin.name),
    );
    if (ok) await QuickPinService.instance.remove(pin.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 6,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.surface.withValues(alpha: 0.96),
      child: Container(
        width: panelWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.secondary.withValues(alpha: 0.28),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 4, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.quickPin,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: l10n.close,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: FilledButton.tonalIcon(
                onPressed: enabled ? () => _showAddDialog(context) : null,
                icon: const Icon(Icons.add, size: 16),
                label: Text(
                  l10n.addCurrentLocation,
                  style: const TextStyle(fontSize: 12),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: pins.isEmpty
                  ? _EmptyPinHint(text: l10n.quickPinEmptyHint)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: pins.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 4),
                      itemBuilder: (context, index) => _QuickPinListItem(
                        pin: pins[index],
                        index: index,
                        isSelected: pins[index].id == selectedPinId,
                        enabled: enabled,
                        onTap: () => onPinSelected(pins[index]),
                        onLongPress: () => _confirmDelete(context, pins[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPinHint extends StatelessWidget {
  final String text;

  const _EmptyPinHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),
    );
  }
}

class _QuickPinListItem extends StatelessWidget {
  final QuickPin pin;
  final int index;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _QuickPinListItem({
    required this.pin,
    required this.index,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final color = QuickPinColors.listColor(index);

    return Material(
      color: isSelected ? color.withValues(alpha: 0.18) : Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: color,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pin.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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
