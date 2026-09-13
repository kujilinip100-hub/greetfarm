import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/language_service.dart';

// Pending/Ready/Collected status-ஐ ஒரு அழகான colored pill ஆ காட்ட
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  String _translatedStatus(String status) {
    switch (status) {
      case "Pending":
        return LanguageService.t("status_pending");
      case "Ready":
        return LanguageService.t("status_ready");
      case "Collected":
        return LanguageService.t("status_collected");
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        _translatedStatus(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}