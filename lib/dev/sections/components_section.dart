import 'package:flutter/material.dart';
import 'package:vasc_pro/components/account_bar.dart';
import 'package:vasc_pro/components/alert_banner.dart';
import 'package:vasc_pro/components/app_badge.dart';
import 'package:vasc_pro/components/app_button.dart';
import 'package:vasc_pro/components/app_input.dart';
import 'package:vasc_pro/components/app_radio.dart';
import 'package:vasc_pro/components/bottom_tab_bar.dart';
import 'package:vasc_pro/components/energy_bar.dart';
import 'package:vasc_pro/components/metric_ring.dart';
import 'package:vasc_pro/components/option_card.dart';
import 'package:vasc_pro/components/promo_card.dart';
import 'package:vasc_pro/components/status_pill.dart';
import 'package:vasc_pro/components/stress_card.dart';
import 'package:vasc_pro/design_system/app_colors.dart';
import 'package:vasc_pro/dev/library/canvas_stage.dart';
import 'package:vasc_pro/dev/library/library_models.dart';

/// The "Components" section registry: one [LibraryEntry] per user component,
/// each showing that component's variants on a light [ComponentStage] so the
/// (light-themed) primitives stay legible on the dark canvas.
LibrarySection componentsSection() {
  return LibrarySection(
    title: 'Components',
    entries: [
      LibraryEntry(
        id: 'cmp-buttons',
        label: 'Buttons',
        icon: Icons.smart_button,
        builder: (_) => _buttons(),
      ),
      LibraryEntry(
        id: 'cmp-inputs',
        label: 'Inputs',
        icon: Icons.text_fields,
        builder: (_) => _inputs(),
      ),
      LibraryEntry(
        id: 'cmp-badges',
        label: 'Badges',
        icon: Icons.label_outline,
        builder: (_) => _badges(),
      ),
      LibraryEntry(
        id: 'cmp-selection',
        label: 'Selection',
        icon: Icons.radio_button_checked,
        builder: (_) => _selection(),
      ),
      LibraryEntry(
        id: 'cmp-cards',
        label: 'Cards',
        icon: Icons.crop_square,
        builder: (_) => _cards(),
      ),
      // ── Bevel home-screen components ─────────────────────────────────────
      LibraryEntry(
        id: 'cmp-account-bar',
        label: 'Account Bar',
        icon: Icons.account_circle_outlined,
        builder: (_) => _accountBar(),
      ),
      LibraryEntry(
        id: 'cmp-status-pills',
        label: 'Status Pills',
        icon: Icons.run_circle_outlined,
        builder: (_) => _statusPills(),
      ),
      LibraryEntry(
        id: 'cmp-alert-banner',
        label: 'Alert Banner',
        icon: Icons.warning_amber_rounded,
        builder: (_) => _alertBanner(),
      ),
      LibraryEntry(
        id: 'cmp-metric-rings',
        label: 'Metric Rings',
        icon: Icons.donut_large,
        builder: (_) => _metricRings(),
      ),
      LibraryEntry(
        id: 'cmp-stress-card',
        label: 'Stress Card',
        icon: Icons.monitor_heart_outlined,
        builder: (_) => _stressCard(),
      ),
      LibraryEntry(
        id: 'cmp-energy-bar',
        label: 'Energy Bar',
        icon: Icons.bolt,
        builder: (_) => _energyBar(),
      ),
      LibraryEntry(
        id: 'cmp-promo-card',
        label: 'Promo Card',
        icon: Icons.auto_awesome,
        builder: (_) => _promoCard(),
      ),
      LibraryEntry(
        id: 'cmp-bottom-nav',
        label: 'Bottom Nav',
        icon: Icons.dock,
        builder: (_) => _bottomNav(),
      ),
    ],
  );
}

/// Shared page scaffold: a stealth header, then the component variants on a
/// light stage.
Widget _page({
  required String title,
  required String subtitle,
  required List<Widget> variants,
  double width = 393,
}) {
  return ListView(
    padding: const EdgeInsets.all(32),
    children: [
      CanvasHeader(title: title, subtitle: subtitle),
      ComponentStage(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: variants,
        ),
      ),
    ],
  );
}

Widget _buttons() => _page(
      title: 'Buttons',
      subtitle: 'Primary and ghost variants of AppButton.',
      variants: const [
        AppButton(label: 'Primary'),
        SizedBox(height: 16),
        AppButton(label: 'Ghost', variant: AppButtonVariant.ghost),
      ],
    );

Widget _inputs() => _page(
      title: 'Inputs',
      subtitle: 'Labeled text field and an obscured password field.',
      variants: const [
        AppInput(label: 'Email', hint: 'you@example.com'),
        SizedBox(height: 16),
        AppInput(label: 'Password', hint: '••••••••', obscureText: true),
      ],
    );

Widget _badges() => _page(
      title: 'Badges',
      subtitle: 'Neutral, success and danger tones of AppBadge.',
      variants: const [
        AppBadge(label: 'Neutral'),
        SizedBox(height: 12),
        AppBadge(label: 'Success', tone: AppBadgeTone.success),
        SizedBox(height: 12),
        AppBadge(label: 'Danger', tone: AppBadgeTone.danger),
      ],
    );

Widget _selection() => _page(
      title: 'Selection',
      subtitle: 'AppRadio in selected and unselected states.',
      variants: const [
        AppRadio(label: 'Selected option', selected: true),
        SizedBox(height: 8),
        AppRadio(label: 'Unselected option', selected: false),
      ],
    );

Widget _cards() => _page(
      title: 'Cards',
      subtitle: 'OptionCard in selected and unselected states.',
      variants: const [
        OptionCard(
          title: 'Selected card',
          subtitle: 'Highlighted with the accent border',
          selected: true,
        ),
        SizedBox(height: 16),
        OptionCard(
          title: 'Unselected card',
          subtitle: 'Default resting state',
          selected: false,
        ),
      ],
    );

// ── Bevel home-screen component showcases ────────────────────────────────────

Widget _accountBar() => _page(
      title: 'Account Bar',
      subtitle: 'Top-right share + avatar pill.',
      variants: const [
        Align(
          alignment: Alignment.centerRight,
          child: AccountBar(initials: 'DC'),
        ),
      ],
    );

Widget _statusPills() => _page(
      title: 'Status Pills',
      subtitle: 'Tinted icon badge or plain icon, title + subtitle.',
      variants: const [
        StatusPill(
          icon: Icons.directions_run,
          iconBackground: AppColors.accentGreen,
          iconColor: AppColors.onPrimary,
          title: 'Active',
          subtitle: 'Until changed',
          showChevron: true,
        ),
        SizedBox(height: 12),
        StatusPill(
          icon: Icons.near_me_outlined,
          title: '—°F',
          subtitle: 'No location',
        ),
      ],
    );

Widget _alertBanner() => _page(
      title: 'Alert Banner',
      subtitle: 'Colored-border attention banner with arrow.',
      variants: const [
        AlertBanner(text: 'Why do I have no data?'),
      ],
    );

Widget _metricRings() => _page(
      title: 'Metric Rings',
      subtitle: 'Circular progress dials in a divided card.',
      variants: const [
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
      ],
    );

Widget _stressCard() => _page(
      title: 'Stress Card',
      subtitle: 'Stat row + dotted radial gauge.',
      variants: const [
        StressCard(
          updated: 'Last updated at 12:22 PM',
          highest: '—',
          lowest: '—',
          average: '—',
        ),
      ],
    );

Widget _energyBar() => _page(
      title: 'Energy Bar',
      subtitle: 'Segmented tick meter with bolt + percentage.',
      variants: const [
        EnergyBar(value: 0.01, percentLabel: '1%'),
      ],
    );

Widget _promoCard() => _page(
      title: 'Promo Card',
      subtitle: 'Gradient upsell card with logo and action.',
      variants: [
        PromoCard(
          title: 'Upgrade to Bevel Pro',
          body: 'Get more out of your data with Bevel Intelligence and '
              'understand your health better.',
          onAction: () {},
          onClose: () {},
        ),
      ],
    );

Widget _bottomNav() => _page(
      title: 'Bottom Nav',
      subtitle: 'Tab bar with floating add button.',
      width: 460,
      variants: [
        BottomTabBar(currentIndex: 0, onTap: (_) {}, onAdd: () {}),
      ],
    );
