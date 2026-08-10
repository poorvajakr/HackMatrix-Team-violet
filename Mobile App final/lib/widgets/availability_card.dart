import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class AvailabilityCard extends StatelessWidget {
  final int icuAvailable;
  final int roomsAvailable;
  final bool emergency;

  const AvailabilityCard({
    super.key,
    required this.icuAvailable,
    required this.roomsAvailable,
    required this.emergency,
  });

  @override
  Widget build(BuildContext context) {
    return PortalPanel(
      child: Row(
        children: [
          Expanded(
            child: _AvailabilityMetric(
              icon: Icons.emergency_outlined,
              label: 'Emergency',
              value: emergency ? 'YES' : 'NO',
              color: emergency ? AppColors.danger : AppColors.muted,
            ),
          ),
          const _Divider(),
          Expanded(
            child: _AvailabilityMetric(
              icon: Icons.monitor_heart_outlined,
              label: 'ICU free',
              value: icuAvailable.toString(),
              color: AppColors.cyan,
            ),
          ),
          const _Divider(),
          Expanded(
            child: _AvailabilityMetric(
              icon: Icons.bed_outlined,
              label: 'Beds free',
              value: roomsAvailable.toString(),
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: AppColors.border,
    );
  }
}

class _AvailabilityMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _AvailabilityMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 21),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
