import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bytepass/ui/pages/dashboard.dart';
import 'package:bytepass/ui/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  final bool loggedIn;

  const HomePage({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Lottie.asset('assets/splash.json'),
        nextScreen: loggedIn ? const DashboardPage() : const LoginPage(),
        splashIconSize: 420,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
