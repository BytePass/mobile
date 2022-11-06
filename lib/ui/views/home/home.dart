import 'package:bytepass/ui/views/dashboard.dart';
import 'package:bytepass/ui/views/auth/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final bool loggedIn;

  const HomePage({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // if user is logged in show dashboard page, otherwise show login page
      body: loggedIn ? const DashboardPage() : const LoginPage(),
    );
  }
}
