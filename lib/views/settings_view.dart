import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class SettingsView extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  const SettingsView({
    super.key,
    this.themeMode = ThemeMode.dark,
    this.onThemeModeChanged,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.themeMode == ThemeMode.dark;
  }

  @override
  void didUpdateWidget(covariant SettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.themeMode != oldWidget.themeMode) {
      _isDarkMode = widget.themeMode == ThemeMode.dark;
    }
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    final ThemeMode newMode = value ? ThemeMode.dark : ThemeMode.light;
    widget.onThemeModeChanged?.call(newMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark mode'),
              subtitle: const Text('Switch between dark and light themes'),
              value: _isDarkMode,
              onChanged: _toggleTheme,
            ),
          ],
        ),
      ),
    );
  }
}
