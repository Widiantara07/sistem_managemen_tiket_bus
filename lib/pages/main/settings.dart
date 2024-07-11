import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/auth_provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: Colors.red,
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final provider =
                          Provider.of<UserAuthProvider>(context, listen: false);
                      await provider.logout();

                      if (!mounted) return;

                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/welcome', (C) => false);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
