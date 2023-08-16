import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:package_info_plus/package_info_plus.dart';

import '../widget/launch_url.dart';

abstract class CustomScaffoldMessenger {
  static void showMessageSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        width: MediaQuery.of(context).size.width > 700 ? 400 : null,
      ),
    );
  }

  static void showErrorMessageSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        content: Align(
          alignment: Alignment.centerLeft,
          child: SelectionArea(
            child: Text(
              error,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.onErrorContainer,
        behavior: SnackBarBehavior.floating,
        width: MediaQuery.of(context).size.width > 700 ? 400 : null,
        duration: const Duration(
          seconds: 10,
        ),
        action: SnackBarAction(
          label: 'Report',
          textColor: Theme.of(context).colorScheme.onErrorContainer,
          onPressed: () async {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            if (context.mounted) {
              CustomLaunchUrl.launch(context,
                  'mailto:admin@jhihyulin.live?subject=%5BWebsite%5D%20Error%20Report&body=%5BError%5D%3A%20$error%0D%0A%0D%0A%5BRoute%5D%3A%20${ModalRoute.of(context)?.settings.name}%0D%0A%0D%0A%5BTime%5D%3A%20${'${DateTime.now().toLocal()} ${DateTime.now().timeZoneName}'}%0D%0A%0D%0A%5BUserAgent%5D%3A%20${html.window.navigator.userAgent}%0D%0A%0D%0A%5BVersion%5D%3A%20${packageInfo.version}+${packageInfo.buildNumber}');
            }
          },
        ),
      ),
    );
  }
}
