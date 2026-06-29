import 'package:flutter/material.dart';
import 'package:vasc_pro/components/app_badge.dart';
import 'package:vasc_pro/components/app_button.dart';
import 'package:vasc_pro/components/app_input.dart';
import 'package:vasc_pro/components/app_radio.dart';
import 'package:vasc_pro/components/option_card.dart';
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
    ],
  );
}

/// Shared page scaffold: a stealth header, then the component variants on a
/// light stage.
Widget _page({
  required String title,
  required String subtitle,
  required List<Widget> variants,
}) {
  return ListView(
    padding: const EdgeInsets.all(32),
    children: [
      CanvasHeader(title: title, subtitle: subtitle),
      ComponentStage(
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
