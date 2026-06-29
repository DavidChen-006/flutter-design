import 'package:flutter/material.dart';

/// A generic placeholder screen for demo board nodes. Renders in its own (light)
/// theme inside a DeviceFrame — swap it for a real feature screen when you build
/// one. Kept app-agnostic so the base scaffold stays generic.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.widgets_outlined, size: 48, color: Color(0xFF9AA0A6)),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1C),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF8A8A8E)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
