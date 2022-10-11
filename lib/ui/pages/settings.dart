import 'package:bytepass/storage.dart';
import 'package:bytepass/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsSectionBackground: Theme.of(context).colorScheme.background,
          settingsListBackground: Theme.of(context).colorScheme.background,
        ),
        darkTheme: SettingsThemeData(
          settingsSectionBackground: Theme.of(context).colorScheme.background,
          settingsListBackground: Theme.of(context).colorScheme.background,
        ),
        sections: [
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile(
                onPressed: (context) async {
                  await Storage.deleteAll();

                  if (mounted) NavigatorPage.login(context);
                },
                title: const Text('Log out'),
                description: const Text('Delete all account data from application storage'),
                leading: const Icon(Icons.logout),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Other'),
            tiles: [
              SettingsTile(
                onPressed: (context) async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  String version = packageInfo.version;
                  String build = packageInfo.buildNumber;

                  if (!mounted) return;

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('About'),
                          content:
                              Text('Application version: $version ($build)'),
                        );
                      });
                },
                title: const Text('About'),
                leading: const Icon(Icons.info),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
