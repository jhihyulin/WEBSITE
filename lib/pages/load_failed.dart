import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;

import '../widget/scaffold_messenger.dart';
import '../widget/card.dart';

class LoadFailedPage extends StatefulWidget {
  const LoadFailedPage({Key? key, required this.errorMessage})
      : super(key: key);
  final String errorMessage;

  @override
  State<LoadFailedPage> createState() => _LoadFailedPageState();
}

class _LoadFailedPageState extends State<LoadFailedPage> {
  late String errorMessage;

  @override
  void initState() {
    super.initState();
    errorMessage = widget.errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Load Failed'),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: 700,
            minHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Load Failed',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomCard(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(
                    maxHeight: 500,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SelectionArea(
                      child: Text(errorMessage),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Back To Home Page'),
                  ),
                  TextButton(
                    child: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: errorMessage),
                      );
                      CustomScaffoldMessenger.showMessageSnackBar(
                          context, 'Copied to clipboard.');
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      html.window.location.reload();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try To Reload'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
