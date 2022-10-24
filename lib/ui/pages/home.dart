import 'package:bytepass/ui/pages/dashboard.dart';
import 'package:bytepass/ui/pages/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final bool loggedIn;

  const HomePage({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loggedIn ? const DashboardPage() : const LoginPage(),
    );
  }
}
