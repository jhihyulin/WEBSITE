import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import '../widget/launch_url.dart';

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
            CustomLaunchUrl.launch(context, 'mailto:admin@jhihyulin.live?subject=%5BWebsite%5D%20Error%20Report&body=%5BError%5D%3A%20$error%0D%0A%0D%0A%5BRoute%5D%3A%20${ModalRoute.of(context)?.settings.name}%0D%0A%0D%0A%5BTime%5D%3A%20${'${DateTime.now().toLocal()} ${DateTime.now().timeZoneName}'}%0D%0A%0D%0A%5BUserAgent%5D%3A%20${html.window.navigator.userAgent}');
          },
        ),
      ),
    );
  }
}
