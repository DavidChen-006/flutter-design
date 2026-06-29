import 'package:flutter/material.dart';
import '../../components/account_bar.dart';
import '../../components/alert_banner.dart';
import '../../components/bottom_tab_bar.dart';
import '../../components/date_header.dart';
import '../../components/energy_bar.dart';
import '../../components/metric_ring.dart';
import '../../components/promo_card.dart';
import '../../components/section_header.dart';
import '../../components/status_pill.dart';
import '../../components/stress_card.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../dev/library/inspectable.dart';

/// LAYER 3 — The Bevel home screen, composed entirely from the extracted
/// Bevel components (which read only from the design tokens). The same widget
/// renders in the live App and as a frame in the "Home Screen" storyboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                120, // room for the floating tab bar
              ),
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Inspectable(AccountBar(initials: 'DC')),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Inspectable(DateHeader(label: 'Today, June 29')),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: const [
                    Expanded(
                      flex: 3,
                      child: Inspectable(
                        StatusPill(
                          icon: Icons.directions_run,
                          iconBackground: AppColors.accentGreen,
                          iconColor: AppColors.onPrimary,
                          title: 'Active',
                          subtitle: 'Until changed',
                          showChevron: true,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: Inspectable(
                        StatusPill(
                          icon: Icons.near_me_outlined,
                          title: '—°F',
                          subtitle: 'No location',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Inspectable(AlertBanner(text: 'Why do I have no data?')),
                const SizedBox(height: AppSpacing.md),
                const Inspectable(
                  MetricRingRow(
                    rings: [
                      MetricRing(
                        value: '0%',
                        label: 'Strain',
                        progress: 0.18,
                        color: AppColors.accentOrange,
                      ),
                      MetricRing(value: '-%', label: 'Recovery', active: false),
                      MetricRing(value: '-%', label: 'Sleep', active: false),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Inspectable(
                  PromoCard(
                    title: 'Upgrade to Bevel Pro',
                    body:
                        'Get more out of your data with Bevel Intelligence and '
                        'understand your health better.',
                    onAction: () {},
                    onClose: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const Inspectable(SectionHeader(title: 'Stress & Energy')),
                const SizedBox(height: AppSpacing.md),
                const Inspectable(
                  StressCard(
                    updated: 'Last updated at 12:22 PM',
                    highest: '—',
                    lowest: '—',
                    average: '—',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Inspectable(EnergyBar(value: 0.01, percentLabel: '1%')),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.md,
            child: SafeArea(
              top: false,
              child: Inspectable(
                BottomTabBar(currentIndex: 0, onTap: (_) {}, onAdd: () {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
