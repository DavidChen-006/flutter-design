import 'package:flutter/material.dart';
import 'workbench_theme.dart';

/// Logical iPhone dimensions + safe-area insets. The architecture leaves room
/// for a device picker later; ships with one default.
class DeviceSpec {
  const DeviceSpec({
    required this.name,
    required this.size,
    required this.safeTop,
    required this.safeBottom,
    required this.radius,
  });

  final String name;
  final Size size;
  final double safeTop; // dynamic island
  final double safeBottom; // home indicator
  final double radius; // screen corner radius

  static const iphone15 = DeviceSpec(
    name: 'iPhone 15',
    size: Size(393, 852),
    safeTop: 59,
    safeBottom: 34,
    radius: 47,
  );
}

/// Renders any screen TRUE TO IPHONE DIMENSIONS inside the desktop canvas: a
/// realistic phone bezel with a dynamic island, clipped corners, a status bar,
/// an opaque screen surface, and — crucially — a MediaQuery override so
/// `SafeArea`/insets behave exactly like a real phone (fixes "everything is
/// treated like a macOS web app"). The child is the user's app screen and
/// renders in the user's own (light) theme on top of [screenBackground].
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    super.key,
    required this.child,
    this.spec = DeviceSpec.iphone15,
    this.label,
    this.screenBackground = const Color(0xFFFFFFFF),
  });

  final Widget child;
  final DeviceSpec spec;
  final String? label;

  /// Opaque surface painted behind the screen so screens without their own
  /// background don't show the dark workbench through them.
  final Color screenBackground;

  static const double _bezel = 10;
  static const Color _bezelColor = Color(0xFF0B0B0E);

  @override
  Widget build(BuildContext context) {
    final outerRadius = spec.radius + _bezel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: Workbench.sectionHeader.copyWith(color: Workbench.textMuted),
          ),
          const SizedBox(height: 14),
        ],
        Container(
          width: spec.size.width + _bezel * 2,
          height: spec.size.height + _bezel * 2,
          padding: const EdgeInsets.all(_bezel),
          decoration: BoxDecoration(
            color: _bezelColor,
            borderRadius: BorderRadius.circular(outerRadius),
            // Subtle hairline edge highlight — depth without harsh borders.
            border: Border.all(color: const Color(0x14FFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x59000000),
                blurRadius: 40,
                spreadRadius: -4,
                offset: Offset(0, 22),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(spec.radius),
            child: SizedBox(
              width: spec.size.width,
              height: spec.size.height,
              child: MediaQuery(
                data: MediaQueryData(
                  size: spec.size,
                  devicePixelRatio: 3,
                  textScaler: TextScaler.noScaling,
                  padding: EdgeInsets.only(
                    top: spec.safeTop,
                    bottom: spec.safeBottom,
                  ),
                ),
                child: Stack(
                  children: [
                    // Opaque screen surface behind everything.
                    Positioned.fill(child: ColoredBox(color: screenBackground)),
                    Positioned.fill(child: child),
                    _StatusBar(height: spec.safeTop),
                    const _DynamicIsland(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The pill-shaped camera/sensor housing near the top center, for realism.
class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 11,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 120,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

/// Minimal iOS-style status bar drawn in the top safe-area inset. Dark glyphs
/// because the app preview behind it is light-themed.
class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    const glyph = Color(0xFF0F172A);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 26, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              '9:41',
              style: TextStyle(
                color: glyph,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Icon(Icons.signal_cellular_alt, size: 16, color: glyph),
                  SizedBox(width: 6),
                  Icon(Icons.wifi, size: 16, color: glyph),
                  SizedBox(width: 6),
                  Icon(Icons.battery_full, size: 18, color: glyph),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
