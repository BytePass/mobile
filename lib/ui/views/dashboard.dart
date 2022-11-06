import 'package:bytepass/ui/views/vault.dart';
import 'package:bytepass/ui/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _State();
}

class _State extends State<DashboardPage> {
  // currently page
  dynamic page = const VaultPage();

  void _handlePageChange(int index) {
    setState(() {
      if (index == 0) {
        page = const VaultPage();
      }

      if (index == 1) {
        page = const SettingsPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: GNav(
        tabBackgroundColor: Colors.purple.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        gap: 8,
        onTabChange: _handlePageChange,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
          ),
        ],
      ),
      body: page,
    );
  }
}
