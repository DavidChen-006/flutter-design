import 'package:flutter/material.dart';
import 'design_system/app_theme.dart';
import 'dev/library/library.dart';
import 'dev/library/library_shell.dart';

class VascProApp extends StatelessWidget {
  const VascProApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The root theme is the USER's app theme — the screens shown inside device
    // frames render in it. The workbench chrome styles itself explicitly via
    // the stealth `Workbench` tokens, independent of this theme.
    return MaterialApp(
      title: 'Vasc Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: LibraryShell(sections: buildLibrarySections()),
    );
  }
}
