import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class loadFailedPage extends StatelessWidget {
  late String _errorMessage;
  loadFailedPage({Key? key, required String errorMessage}) : super(key: key) {
    _errorMessage = errorMessage;
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
                    Text('Load Failed',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 20),
                    Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        constraints: const BoxConstraints(maxHeight: 500),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: SelectionArea(
                            child: Text(_errorMessage),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
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
                                ClipboardData(text: _errorMessage));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to clipboard'),
                                showCloseIcon: true,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.0))),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ))));
  }
}