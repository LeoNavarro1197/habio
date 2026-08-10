import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_components.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final theme = Theme.of(context);
    final controller = ref.read(settingsControllerProvider.notifier);
    final priceLabel = controller.premiumPriceLabel;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      children: [
        Text(l10n.settingsTitle, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
        Text(
          l10n.settingsNotificationsHeader,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard([
          _settingTile(
            icon: Icons.notifications_outlined,
            title: l10n.settingsNotificationsLabel,
            subtitle: l10n.settingsNotificationsSubtitle,
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: (value) async {
                if (value) {
                  await NotificationServiceHolder.instance
                      .requestPermissions();
                }
                await ref
                    .read(settingsControllerProvider.notifier)
                    .toggleNotifications(value);
              },
            ),
          ),
        ]),
        const SizedBox(height: 24),
        Text(
          l10n.settingsAppHeader,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard([
          _settingTile(
            icon: Icons.info_outline,
            title: l10n.settingsVersionLabel,
            subtitle: AppConstants.appVersion,
          ),
        ]),
        const SizedBox(height: 24),
        Text(
          l10n.settingsPremiumHeader,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        _premiumCard(context, l10n, settings, controller, priceLabel),
        const SizedBox(height: 10),
        _sectionCard([
          _settingTile(
            icon: Icons.restore_outlined,
            title: l10n.settingsRestoreLabel,
            subtitle: l10n.settingsRestoreSubtitle,
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              await ref
                  .read(settingsControllerProvider.notifier)
                  .restorePurchases();
              if (context.mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.settingsRestoredSnackbar),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 4),
          _settingTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.settingsPrivacyLabel,
            subtitle: l10n.settingsPrivacySubtitle,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.settingsPrivacyDialogTitle),
                  content: SingleChildScrollView(
                    child: Text(l10n.settingsPrivacyContent),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.close),
                    ),
                  ],
                ),
              );
            },
          ),
        ]),
      ],
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: ListTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          title: Text(title,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle,
              style: const TextStyle(
                  color: AppColors.textTertiary, fontSize: 12)),
          trailing: trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }

  Widget _premiumCard(BuildContext context, AppLocalizations l10n,
      SettingsState settings, SettingsController controller, String? priceLabel) {
    if (settings.adsRemoved) {
      return GlassCard(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.verified_rounded,
                  color: AppColors.success, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsPremiumOwnedTitle,
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(l10n.settingsPremiumOwnedSubtitle,
                      style: TextStyle(
                          color: AppColors.textTertiary, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.secondary.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.settingsPremiumBuyTitle,
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(l10n.settingsPremiumBuySubtitle,
                        style: TextStyle(
                            color: AppColors.textTertiary, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () async {
                  final started = await controller.buyPremium();
                  if (!started && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.settingsPremiumNotAvailable),
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(priceLabel ?? l10n.buy),
              ),
            ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GradientBorderPainter(
                   radius: 10,
                  borderWidth: 1,
                  gradient: const LinearGradient(
                                    colors: [AppColors.border, AppColors.border],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              color: AppColors.card,
            ),
            child: Column(children: children),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GradientBorderPainter(
                   radius: 10,
                  borderWidth: 1,
                  gradient: const LinearGradient(
                                    colors: [AppColors.border, AppColors.border],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
