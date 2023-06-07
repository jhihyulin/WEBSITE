import 'package:flutter/material.dart';

abstract class CustomScaffoldMessenger {
  static void showMessageSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showErrorMessageSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        content: SelectionArea(
          child: Text(
            error,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.onErrorContainer,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          seconds: 10,
        ),
        action: SnackBarAction(
          label: 'Report',
          textColor: Theme.of(context).colorScheme.onErrorContainer,
          onPressed: () {
            // TODO: add email report function
          },
        ),
      ),
    );
  }
}
