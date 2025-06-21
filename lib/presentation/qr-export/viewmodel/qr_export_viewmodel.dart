import 'dart:async';
import 'dart:convert';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/data/data_source/local_data_source.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class QrExportViewModel extends BaseViewModel
    implements QrExportViewModelInputs, QrExportViewModelOutputs {
  final LocalDataSource _localDataSource;
  final AppPrefs _appPrefs;

  final _qrDataController = BehaviorSubject<String>();

  QrExportViewModel(this._localDataSource, this._appPrefs);

  @override
  void start() {
    _generateQrData();
  }

  Future<void> _generateQrData() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );

    try {
      // 1. Get List Data
      final todos = await _localDataSource.getTodo();
      final finished = await _localDataSource.getFinished();
      final history = await _localDataSource.getHistory();

      // 2. Get Settings Data
      final settings = {
        'language': await _appPrefs.getLanguage(),
        'themeMode': await _appPrefs.getThemeMode(),
        'manualTheme': await _appPrefs.getManualTheme(),
        'fontType': await _appPrefs.getFontType(),
        'rawgKey': await _appPrefs.getCustomRawgApiKey(),
        'tmdbKey': await _appPrefs.getCustomTmdbApiKey(),
        'booksKey': await _appPrefs.getCustomBooksApiKey(),
      };

      // 3. Combine into a single backup object
      final backupData = {
        'app_id': 'noted_backup', // For validation on import
        'version': '1.0',
        'settings': settings,
        'lists': {
          'todos': todos.map((e) => e.toJson()).toList(),
          'finished': finished.map((e) => e.toJson()).toList(),
          'history': history.map((e) => e.toJson()).toList(),
        },
      };

      final String jsonData = jsonEncode(backupData);
      inputQrData.add(jsonData);
      inputState.add(ContentState());
    } catch (e) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.fullScreenErrorState,
          message: 'Failed to generate QR data: ${e.toString()}',
        ),
      );
    }
  }

  @override
  void dispose() {
    _qrDataController.close();
    super.dispose();
  }

  @override
  Sink<String> get inputQrData => _qrDataController.sink;

  @override
  Stream<String> get outputQrData => _qrDataController.stream;
}

abstract class QrExportViewModelInputs {
  Sink<String> get inputQrData;
}

abstract class QrExportViewModelOutputs {
  Stream<String> get outputQrData;
}
