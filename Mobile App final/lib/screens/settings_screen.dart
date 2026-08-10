import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        children: [
          const SectionTitle(
            title: 'Preferences',
            subtitle: 'Personalize your MedSync experience',
          ),
          const SizedBox(height: 12),
          PortalPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Booking and hospital updates',
                  onTap: () {},
                ),
                const Divider(),
                _SettingTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'About'),
          const SizedBox(height: 12),
          PortalPanel(
            padding: EdgeInsets.zero,
            child: _SettingTile(
              icon: Icons.info_outline_rounded,
              title: 'About MedSync',
              subtitle: 'Patient care network',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: AppColors.cyan, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 10,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.muted,
      ),
      onTap: onTap,
    );
  }
}
