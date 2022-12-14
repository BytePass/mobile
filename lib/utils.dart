import 'package:bytepass/ui/views/dashboard.dart';
import 'package:bytepass/ui/views/auth/login.dart';
import 'package:bytepass/ui/views/auth/register.dart';
import 'package:bytepass/ui/views/vault_add_item.dart';
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

  static void vaultAddItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VaultAddItemPage()),
    );
  }
}
