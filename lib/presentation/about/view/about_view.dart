import 'package:flutter/material.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,

        title: Text(t.settings.about),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_AboutAppCard(), SizedBox(height: 16), _ApisUsedCard()],
          ),
        ),
      ),
    );
  }
}

class _AboutAppCard extends StatelessWidget {
  const _AboutAppCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.about.aboutThisApp,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(t.about.appDescription, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}

class _ApisUsedCard extends StatelessWidget {
  const _ApisUsedCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.about.apisUsed,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _ApiInfo(
                  title: t.home.games,
                  description: t.about.gamesDescription,
                ),
                const SizedBox(height: 8),
                _ApiInfo(
                  title: t.about.moviesAndTvSeries,
                  description: t.about.moviesAndTvSeriesDescription,
                ),
                const SizedBox(height: 8),
                _ApiInfo(
                  title: t.home.books,
                  description: t.about.booksDescription,
                ),
                const SizedBox(height: 16),
                Text(
                  t.about.thanksMessage,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

class _ApiInfo extends StatelessWidget {
  final String title;
  final String description;

  const _ApiInfo({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(description, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
