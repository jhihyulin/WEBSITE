import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go To Home Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
