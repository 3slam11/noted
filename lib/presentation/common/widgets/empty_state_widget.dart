import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/gen/strings.g.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Center(
        child: Column(
          children: [
            Icon(
                  Icons.list_alt,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.5, 0.5))
                .then()
                .shake(duration: 500.ms, delay: 1000.ms)
                .then(delay: 2000.ms)
                .shake(duration: 500.ms),
            const SizedBox(height: 10),
            Text(t.home.emptySection, style: const TextStyle(fontSize: 15))
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
