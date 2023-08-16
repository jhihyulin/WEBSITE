import 'package:url_launcher/url_launcher.dart';

import '../widget/scaffold_messenger.dart';

abstract class CustomLaunchUrl {
  static void launch(context, String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (context.mounted) {
        CustomScaffoldMessenger.showErrorMessageSnackBar(
            context, 'Error: Could not launch $url');
      }
      throw Exception('Error: Could not launch $url');
    }
  }
}
