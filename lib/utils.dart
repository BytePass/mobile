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
