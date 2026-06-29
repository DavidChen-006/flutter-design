import 'package:flutter/widgets.dart';

/// LAYER 2 — The single shared press-feedback primitive.
///
/// Wrap any tappable widget in [Pressable] to give it ONE consistent press
/// animation: a quick scale + opacity dip on pointer-down that springs back on
/// release. The animation plays whenever the widget is pressed, even if [onTap]
/// is null — so a component's interaction is always demonstrable (e.g. clicking
/// it in the component gallery) without needing to navigate anywhere. Use this
/// instead of ad-hoc InkWell/GestureDetector feedback so every interactive
/// component feels identical.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.96,
  });

  final Widget child;

  /// Fired on tap-up. May be null — the press animation still plays.
  final VoidCallback? onTap;

  /// Scale applied while pressed (1.0 = no shrink).
  final double pressedScale;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  static const _duration = Duration(milliseconds: 90);
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: _duration,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _pressed ? 0.9 : 1.0,
          duration: _duration,
          child: widget.child,
        ),
      ),
    );
  }
}
