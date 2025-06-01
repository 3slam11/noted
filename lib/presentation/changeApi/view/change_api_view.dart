import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/changeApi/viewModel/change_api_viewmodel.dart';
import 'package:noted/presentation/resources/values_manager.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class ChangeApiView extends StatefulWidget {
  const ChangeApiView({super.key});

  @override
  State<ChangeApiView> createState() => _ChangeApiViewState();
}

class _ChangeApiViewState extends State<ChangeApiView> {
  final ChangeApiViewModel _viewModel = instance<ChangeApiViewModel>();

  final TextEditingController _rawgController = TextEditingController();
  final TextEditingController _tmdbController = TextEditingController();
  final TextEditingController _googleBooksController = TextEditingController();

  StreamSubscription? _rawgApiKeySubscription;
  StreamSubscription? _tmdbApiKeySubscription;
  StreamSubscription? _booksApiKeySubscription;

  @override
  void initState() {
    super.initState();
    _viewModel.start();
    _bindViewModel();
  }

  void _bindViewModel() {
    _rawgApiKeySubscription = _viewModel.outputRawgApiKey.listen((apiKey) {
      if (_rawgController.text != apiKey) {
        _rawgController.text = apiKey;
      }
    });
    _tmdbApiKeySubscription = _viewModel.outputTmdbApiKey.listen((apiKey) {
      if (_tmdbController.text != apiKey) {
        _tmdbController.text = apiKey;
      }
    });
    _booksApiKeySubscription = _viewModel.outputBooksApiKey.listen((apiKey) {
      if (_googleBooksController.text != apiKey) {
        _googleBooksController.text = apiKey;
      }
    });
  }

  @override
  void dispose() {
    _rawgApiKeySubscription?.cancel();
    _tmdbApiKeySubscription?.cancel();
    _booksApiKeySubscription?.cancel();

    _rawgController.dispose();
    _tmdbController.dispose();
    _googleBooksController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          t.settings.apiChange,
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildApiInfoCard(
              context,
              title: t.apiSettings.gamesApiTitle,
              description: t.apiSettings.gamesApiDescription,
              url: 'https://rawg.io/apidocs',
              controller: _rawgController,
              apiKeyType: ApiKeyType.rawg,
              isSavedStream: _viewModel.outputIsRawgKeySaved,
              isVisibleStream: _viewModel.outputIsRawgKeyVisible,
            ),
            const SizedBox(height: 16),
            _buildApiInfoCard(
              context,
              title: t.apiSettings.moviesApiTitle,
              description: t.apiSettings.moviesApiDescription,
              url: 'https://www.themoviedb.org/settings/api',
              controller: _tmdbController,
              apiKeyType: ApiKeyType.tmdb,
              isSavedStream: _viewModel.outputIsTmdbKeySaved,
              isVisibleStream: _viewModel.outputIsTmdbKeyVisible,
            ),
            const SizedBox(height: 16),
            _buildApiInfoCard(
              context,
              title: t.apiSettings.booksApiTitle,
              description: t.apiSettings.booksApiDescription,
              url: 'https://console.cloud.google.com/apis/credentials',
              controller: _googleBooksController,
              apiKeyType: ApiKeyType.books,
              isSavedStream: _viewModel.outputIsBooksKeySaved,
              isVisibleStream: _viewModel.outputIsBooksKeyVisible,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    required String url,
    required TextEditingController controller,
    required ApiKeyType apiKeyType,
    required Stream<bool> isSavedStream,
    required Stream<bool> isVisibleStream,
  }) {
    return Card(
      elevation: AppSize.s0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(url);
                await launchUrl(uri);
              },
              child: Text(t.apiSettings.getApiKey),
            ),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<bool>(
                    stream: isVisibleStream,
                    initialData: false,
                    builder: (context, snapshot) {
                      final isVisible = snapshot.data ?? false;
                      return TextFormField(
                        controller: controller,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          labelText: t.apiSettings.apiKey,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              _viewModel.toggleVisibility(apiKeyType);
                            },
                          ),
                        ),
                        obscureText: !isVisible,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                StreamBuilder<bool>(
                  stream: isSavedStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    final isSaved = snapshot.data ?? false;
                    return ElevatedButton(
                      onPressed: () => _viewModel.saveOrDeleteApiKey(
                        apiKeyType,
                        controller.text,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSaved
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isSaved ? t.apiSettings.delete : t.apiSettings.save,

                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
