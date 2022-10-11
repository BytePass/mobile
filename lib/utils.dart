import 'package:bytepass/ui/pages/dashboard.dart';
import 'package:bytepass/ui/pages/login.dart';
import 'package:bytepass/ui/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Utils {
  static void showSnackBar(
    BuildContext context, {
    required String content,
    void Function()? retryAction,
  }) {
    SnackBar snackBar;

    if (retryAction != null) {
      snackBar = SnackBar(
        content: Text(content),
        action: SnackBarAction(
          label: context.localeString('toast_retry'),
          onPressed: retryAction,
        ),
      );
    } else {
      snackBar = SnackBar(content: Text(content));
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class NavigatorPage {
  static void to(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  /// Navigate to [LoginPage].
  static void login(BuildContext context) {
    to(context, const LoginPage());
  }

  /// Navigate to [RegisterPage].
  static void register(BuildContext context) {
    to(context, const RegisterPage());
  }

  /// Navigate to [DashboardPage].
  static void dashboard(BuildContext context) {
    to(context, const DashboardPage());
  }
}
