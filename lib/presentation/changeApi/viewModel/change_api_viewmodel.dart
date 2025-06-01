import 'dart:async';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

enum ApiKeyType { rawg, tmdb, books }

class ChangeApiViewModel extends BaseViewModel
    implements ChangeApiViewModelInputs, ChangeApiViewModelOutputs {
  final AppPrefs _appPrefs;

  // Input controllers for API key text (from view)
  final _rawgApiKeyTextController = BehaviorSubject<String>();
  final _tmdbApiKeyTextController = BehaviorSubject<String>();
  final _booksApiKeyTextController = BehaviorSubject<String>();

  // Output streams for API key values (to view)
  final _outputRawgApiKeyController = BehaviorSubject<String>();
  final _outputTmdbApiKeyController = BehaviorSubject<String>();
  final _outputBooksApiKeyController = BehaviorSubject<String>();

  // Output streams for saved status
  final _isRawgKeySavedController = BehaviorSubject<bool>();
  final _isTmdbKeySavedController = BehaviorSubject<bool>();
  final _isBooksKeySavedController = BehaviorSubject<bool>();

  // Output streams for visibility status
  final _isRawgKeyVisibleController = BehaviorSubject<bool>.seeded(false);
  final _isTmdbKeyVisibleController = BehaviorSubject<bool>.seeded(false);
  final _isBooksKeyVisibleController = BehaviorSubject<bool>.seeded(false);

  ChangeApiViewModel(this._appPrefs);

  @override
  void start() {
    _loadApiKeys();
  }

  @override
  void dispose() {
    _rawgApiKeyTextController.close();
    _tmdbApiKeyTextController.close();
    _booksApiKeyTextController.close();
    _outputRawgApiKeyController.close();
    _outputTmdbApiKeyController.close();
    _outputBooksApiKeyController.close();
    _isRawgKeySavedController.close();
    _isTmdbKeySavedController.close();
    _isBooksKeySavedController.close();
    _isRawgKeyVisibleController.close();
    _isTmdbKeyVisibleController.close();
    _isBooksKeyVisibleController.close();
    super.dispose();
  }

  Future<void> _loadApiKeys() async {
    String rawgKey = await _appPrefs.getCustomRawgApiKey();
    _outputRawgApiKeyController.sink.add(rawgKey);
    _isRawgKeySavedController.sink.add(rawgKey.isNotEmpty);

    String tmdbKey = await _appPrefs.getCustomTmdbApiKey();
    _outputTmdbApiKeyController.sink.add(tmdbKey);
    _isTmdbKeySavedController.sink.add(tmdbKey.isNotEmpty);

    String booksKey = await _appPrefs.getCustomBooksApiKey();
    _outputBooksApiKeyController.sink.add(booksKey);
    _isBooksKeySavedController.sink.add(booksKey.isNotEmpty);
  }

  @override
  void saveOrDeleteApiKey(ApiKeyType type, String currentKeyValue) async {
    bool isCurrentlySaved;
    Function saveFunction;
    Function deleteFunction;
    BehaviorSubject<bool> savedStatusController;
    BehaviorSubject<String> outputKeyController;

    switch (type) {
      case ApiKeyType.rawg:
        isCurrentlySaved = _isRawgKeySavedController.value;
        saveFunction = _appPrefs.setCustomRawgApiKey;
        deleteFunction = _appPrefs.removeCustomRawgApiKey;
        savedStatusController = _isRawgKeySavedController;
        outputKeyController = _outputRawgApiKeyController;
        break;
      case ApiKeyType.tmdb:
        isCurrentlySaved = _isTmdbKeySavedController.value;
        saveFunction = _appPrefs.setCustomTmdbApiKey;
        deleteFunction = _appPrefs.removeCustomTmdbApiKey;
        savedStatusController = _isTmdbKeySavedController;
        outputKeyController = _outputTmdbApiKeyController;
        break;
      case ApiKeyType.books:
        isCurrentlySaved = _isBooksKeySavedController.value;
        saveFunction = _appPrefs.setCustomBooksApiKey;
        deleteFunction = _appPrefs.removeCustomBooksApiKey;
        savedStatusController = _isBooksKeySavedController;
        outputKeyController = _outputBooksApiKeyController;
        break;
    }

    if (isCurrentlySaved) {
      // Delete action
      await deleteFunction();
      outputKeyController.sink.add('');
      savedStatusController.sink.add(false);
    } else {
      // Save action
      if (currentKeyValue.isNotEmpty) {
        await saveFunction(currentKeyValue);
        outputKeyController.sink.add(currentKeyValue);
        savedStatusController.sink.add(true);
      }
    }
  }

  @override
  void toggleVisibility(ApiKeyType type) {
    switch (type) {
      case ApiKeyType.rawg:
        _isRawgKeyVisibleController.sink.add(
          !_isRawgKeyVisibleController.value,
        );
        break;
      case ApiKeyType.tmdb:
        _isTmdbKeyVisibleController.sink.add(
          !_isTmdbKeyVisibleController.value,
        );
        break;
      case ApiKeyType.books:
        _isBooksKeyVisibleController.sink.add(
          !_isBooksKeyVisibleController.value,
        );
        break;
    }
  }

  // --- Inputs ---
  // The view will manage TextEditingControllers and pass their text to saveOrDeleteApiKey.

  // --- Outputs ---
  @override
  Stream<String> get outputRawgApiKey => _outputRawgApiKeyController.stream;
  @override
  Stream<String> get outputTmdbApiKey => _outputTmdbApiKeyController.stream;
  @override
  Stream<String> get outputBooksApiKey => _outputBooksApiKeyController.stream;

  @override
  Stream<bool> get outputIsRawgKeySaved => _isRawgKeySavedController.stream;
  @override
  Stream<bool> get outputIsTmdbKeySaved => _isTmdbKeySavedController.stream;
  @override
  Stream<bool> get outputIsBooksKeySaved => _isBooksKeySavedController.stream;

  @override
  Stream<bool> get outputIsRawgKeyVisible => _isRawgKeyVisibleController.stream;
  @override
  Stream<bool> get outputIsTmdbKeyVisible => _isTmdbKeyVisibleController.stream;
  @override
  Stream<bool> get outputIsBooksKeyVisible =>
      _isBooksKeyVisibleController.stream;
}

abstract class ChangeApiViewModelInputs {
  void saveOrDeleteApiKey(ApiKeyType type, String currentKeyValue);
  void toggleVisibility(ApiKeyType type);
}

abstract class ChangeApiViewModelOutputs {
  Stream<String> get outputRawgApiKey;
  Stream<String> get outputTmdbApiKey;
  Stream<String> get outputBooksApiKey;

  Stream<bool> get outputIsRawgKeySaved;
  Stream<bool> get outputIsTmdbKeySaved;
  Stream<bool> get outputIsBooksKeySaved;

  Stream<bool> get outputIsRawgKeyVisible;
  Stream<bool> get outputIsTmdbKeyVisible;
  Stream<bool> get outputIsBooksKeyVisible;
}
