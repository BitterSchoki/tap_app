import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Action Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => (),
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed: () => (),
              child: const Text('Next'),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
