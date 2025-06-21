import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/data/data_source/local_data_source.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/resources/theme_manager.dart';

class BackupAndRestoreViewModel extends BaseViewModel
    implements
        BackupAndRestoreViewModelInputs,
        BackupAndRestoreViewModelOutputs {
  final LocalDataSource _localDataSource;
  final DataGlobalNotifier _dataGlobalNotifier;
  final AppPrefs _appPrefs;
  final ThemeManager _themeManager;

  BackupAndRestoreViewModel(
    this._localDataSource,
    this._dataGlobalNotifier,
    this._appPrefs,
    this._themeManager,
  );

  @override
  void start() {}

  @override
  Future<void> restoreDataFromQr(String qrData) async {
    try {
      final Map<String, dynamic> backupData = jsonDecode(qrData);

      // Validate the QR data
      if (backupData['app_id'] != 'noted_backup' ||
          !backupData.containsKey('lists') ||
          !backupData.containsKey('settings')) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: 'Invalid QR Code',
          ),
        );
        return;
      }
      // Clear existing data
      await _localDataSource.clearTodo();
      await _localDataSource.clearFinished();
      await _localDataSource.clearHistory();
      // Restore lists
      final Map<String, dynamic> listsData = backupData['lists'];
      if (listsData.containsKey('todos')) {
        final List<dynamic> todosData = listsData['todos'];
        for (var itemData in todosData) {
          await _localDataSource.addTodo(
            ItemResponse.fromJson(itemData as Map<String, dynamic>),
          );
        }
      }
      if (listsData.containsKey('finished')) {
        final List<dynamic> finishedData = listsData['finished'];
        for (var itemData in finishedData) {
          await _localDataSource.addFinished(
            ItemResponse.fromJson(itemData as Map<String, dynamic>),
          );
        }
      }
      if (listsData.containsKey('history')) {
        final List<dynamic> historyData = listsData['history'];
        for (var itemData in historyData) {
          await _localDataSource.addHistory(
            ItemResponse.fromJson(itemData as Map<String, dynamic>),
          );
        }
      }
      // Restore settings
      final Map<String, dynamic> settingsData = backupData['settings'];
      await _appPrefs.setLanguage(settingsData['language']);
      await _appPrefs.setThemeMode(settingsData['themeMode']);
      await _appPrefs.setManualTheme(settingsData['manualTheme']);
      await _appPrefs.setFontType(settingsData['fontType']);
      await _appPrefs.setCustomRawgApiKey(settingsData['rawgKey']);
      await _appPrefs.setCustomTmdbApiKey(settingsData['tmdbKey']);
      await _appPrefs.setCustomBooksApiKey(settingsData['booksKey']);
      // Notify app of changes
      _dataGlobalNotifier.notifyDataImported();
      LocaleSettings.setLocaleRaw(settingsData['language']);
      _themeManager.notifyThemeChange();
      inputState.add(
        SuccessState(
          stateRendererType: StateRendererType.popupSuccessState,
          message: t.backupAndRestore.dataRestoredMessage,
        ),
      );
    } catch (e) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: '${t.backupAndRestore.restoreFailed}${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<void> backupData() async {
    try {
      final todos = await _localDataSource.getTodo();
      final finished = await _localDataSource.getFinished();
      final history = await _localDataSource.getHistory();

      final backupData = {
        'todos': todos.map((e) => e.toJson()).toList(),
        'finished': finished.map((e) => e.toJson()).toList(),
        'history': history.map((e) => e.toJson()).toList(),
      };

      final String jsonData = jsonEncode(backupData);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: t.backupAndRestore.saveBackupFile,
        fileName: t.backupAndRestore.defaultBackupFileName,
        bytes: utf8.encode(jsonData),
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        inputState.add(
          SuccessState(
            stateRendererType: StateRendererType.popupSuccessState,
            message: t.backupAndRestore.backupSuccessful,
          ),
        );
      } else {
        inputState.add(ContentState());
      }
    } catch (e) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: '${t.backupAndRestore.backupFailed}${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<void> restoreData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: t.backupAndRestore.selectBackupFile,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final fileBytes = result.files.single.bytes!;
        final String jsonData = utf8.decode(fileBytes);
        final Map<String, dynamic> backupData = jsonDecode(jsonData);

        if (backupData.containsKey('todos') ||
            backupData.containsKey('finished') ||
            backupData.containsKey('history')) {
          await _localDataSource.clearTodo();
          await _localDataSource.clearFinished();
          await _localDataSource.clearHistory();

          final List<dynamic> todosData = backupData['todos'];
          for (var itemData in todosData) {
            await _localDataSource.addTodo(
              ItemResponse.fromJson(itemData as Map<String, dynamic>),
            );
          }

          final List<dynamic> finishedData = backupData['finished'];
          for (var itemData in finishedData) {
            await _localDataSource.addFinished(
              ItemResponse.fromJson(itemData as Map<String, dynamic>),
            );
          }

          final List<dynamic> historyData = backupData['history'];
          for (var itemData in historyData) {
            await _localDataSource.addHistory(
              ItemResponse.fromJson(itemData as Map<String, dynamic>),
            );
          }

          _dataGlobalNotifier.notifyDataImported();

          inputState.add(
            SuccessState(
              stateRendererType: StateRendererType.popupSuccessState,
              message: t.backupAndRestore.dataRestoredMessage,
            ),
          );
        } else {
          inputState.add(
            ErrorState(
              stateRendererType: StateRendererType.popupErrorState,
              message: t.backupAndRestore.invalidFileFormat,
            ),
          );
        }
      } else {
        inputState.add(ContentState());
      }
    } catch (e) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: '${t.backupAndRestore.restoreFailed}${e.toString()}',
        ),
      );
    }
  }
}

abstract class BackupAndRestoreViewModelInputs {
  Future<void> backupData();
  Future<void> restoreData();
  Future<void> restoreDataFromQr(String qrData);
}

abstract class BackupAndRestoreViewModelOutputs {
  // OutputState is inherited from BaseViewModel
}
