import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/data/data_source/local_data_source.dart';
import 'package:noted/data/objectbox/objectbox_manager.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:objectbox/objectbox.dart';

class BackupAndRestoreViewModel extends BaseViewModel
    implements BackupAndRestoreViewModelInputs {
  final LocalDataSource _localDataSource;
  final AppPrefs _appPrefs;
  final ThemeManager _themeManager;
  final DataGlobalNotifier _dataGlobalNotifier;
  final ObjectBoxManager _objectBoxManager;

  BackupAndRestoreViewModel(
    this._localDataSource,
    this._appPrefs,
    this._themeManager,
    this._dataGlobalNotifier,
    this._objectBoxManager,
  );

  @override
  void start() {}

  @override
  Future<void> backupData() async {
    try {
      final results = await Future.wait([
        _localDataSource.getTodo(),
        _localDataSource.getFinished(),
        _localDataSource.getHistory(),
        _appPrefs.getLanguage(),
        _appPrefs.getThemeMode(),
        _appPrefs.getManualTheme(),
        _appPrefs.getCustomRawgApiKey(),
        _appPrefs.getCustomTmdbApiKey(),
        _appPrefs.getCustomBooksApiKey(),
        _appPrefs.getFontType(),
        _appPrefs.getCustomFontPath(),
        _appPrefs.getCustomFontFamilyName(),
      ]);

      final todos = results[0] as List<ItemResponse>;
      final finished = results[1] as List<ItemResponse>;
      final history = results[2] as List<ItemResponse>;
      final language = results[3] as String;
      final themeMode = results[4] as int;
      final manualTheme = results[5] as int;
      final rawgKey = results[6] as String;
      final tmdbKey = results[7] as String;
      final booksKey = results[8] as String;
      final fontType = results[9] as int;
      final fontPath = results[10] as String;
      final fontFamilyName = results[11] as String?;

      String? customFontBase64;
      if (fontType == FontType.custom.index &&
          fontPath.isNotEmpty &&
          File(fontPath).existsSync()) {
        final fontBytes = await File(fontPath).readAsBytes();
        customFontBase64 = base64Encode(fontBytes);
      }

      final backupData = {
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'lists': {
          'todos': todos.map((e) => e.toJson()).toList(),
          'finished': finished.map((e) => e.toJson()).toList(),
          'history': history.map((e) => e.toJson()).toList(),
        },
        'settings': {
          'language': language,
          'themeMode': themeMode,
          'manualTheme': manualTheme,
          'rawgKey': rawgKey,
          'tmdbKey': tmdbKey,
          'booksKey': booksKey,
          'fontType': fontType,
          'fontFileContentBase64': customFontBase64,
          'fontFamilyName': fontFamilyName,
        },
      };

      final String jsonData = jsonEncode(backupData);

      final String? outputDir = await FilePicker.platform.getDirectoryPath(
        dialogTitle: t.backupAndRestore.saveBackupFile,
      );

      if (outputDir != null) {
        final file = File(
          p.join(outputDir, t.backupAndRestore.defaultBackupFileName),
        );
        await file.writeAsString(jsonData);
        inputState.add(
          SuccessState(
            stateRendererType: StateRendererType.popupSuccessState,
            message: t.backupAndRestore.backupSuccessful,
          ),
        );
      }
    } catch (e, s) {
      debugPrint('Backup failed: $e\n$s');
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

      if (result?.files.single.bytes == null) {
        return;
      }

      final fileBytes = result!.files.single.bytes!;
      final String jsonData = utf8.decode(fileBytes);
      final Map<String, dynamic> backupData = jsonDecode(jsonData);

      await _objectBoxManager.store.runInTransaction(TxMode.write, () async {
        await _restore(backupData);
      });

      _themeManager.notifyThemeChange();
      _dataGlobalNotifier.notifyDataImported();

      inputState.add(
        SuccessState(
          stateRendererType: StateRendererType.popupSuccessState,
          message: t.backupAndRestore.restoreSuccessful,
        ),
      );
    } catch (e, s) {
      debugPrint('Restore failed: $e\n$s');
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: '${t.backupAndRestore.restoreFailed}${e.toString()}',
        ),
      );
    }
  }

  Future<void> _restore(Map<String, dynamic> backupData) async {
    await _localDataSource.clearTodo();
    await _localDataSource.clearFinished();
    await _localDataSource.clearHistory();

    final Map<String, dynamic>? listsData =
        backupData['lists'] as Map<String, dynamic>?;
    if (listsData != null) {
      final todosData = listsData['todos'] as List<dynamic>? ?? [];
      for (var itemData in todosData) {
        await _localDataSource.addTodo(ItemResponse.fromJson(itemData));
      }

      final finishedData = listsData['finished'] as List<dynamic>? ?? [];
      for (var itemData in finishedData) {
        await _localDataSource.addFinished(ItemResponse.fromJson(itemData));
      }

      final historyData = listsData['history'] as List<dynamic>? ?? [];
      for (var itemData in historyData) {
        await _localDataSource.addHistory(ItemResponse.fromJson(itemData));
      }
    }

    final Map<String, dynamic>? settingsData =
        backupData['settings'] as Map<String, dynamic>?;
    if (settingsData != null) {
      final lang = settingsData['language'] as String?;
      if (lang != null) {
        await _appPrefs.setLanguage(lang);
        LocaleSettings.setLocaleRaw(lang);
      }

      await _appPrefs.setCustomRawgApiKey(
        settingsData['rawgKey'] as String? ?? '',
      );
      await _appPrefs.setCustomTmdbApiKey(
        settingsData['tmdbKey'] as String? ?? '',
      );
      await _appPrefs.setCustomBooksApiKey(
        settingsData['booksKey'] as String? ?? '',
      );

      final fontTypeIndex = settingsData['fontType'] as int?;
      if (fontTypeIndex != null) {
        final fontType = FontType.values[fontTypeIndex];
        if (fontType == FontType.custom &&
            settingsData['fontFileContentBase64'] != null) {
          final fontFamilyName = settingsData['fontFamilyName'] as String?;
          final fontBase64 = settingsData['fontFileContentBase64'] as String?;

          if (fontFamilyName != null &&
              fontBase64 != null &&
              fontFamilyName.isNotEmpty &&
              fontBase64.isNotEmpty) {
            final fontBytes = base64Decode(fontBase64);
            final appDir = await getApplicationDocumentsDirectory();
            final fontDir = Directory(p.join(appDir.path, 'fonts'));
            if (!await fontDir.exists()) {
              await fontDir.create(recursive: true);
            }
            final newPath = p.join(
              fontDir.path,
              '${fontFamilyName}_${DateTime.now().millisecondsSinceEpoch}.ttf',
            );
            await File(newPath).writeAsBytes(fontBytes);

            await _appPrefs.setCustomFontPath(newPath);
            await _appPrefs.setCustomFontFamilyName(fontFamilyName);

            final fontLoader = FontLoader(fontFamilyName);
            fontLoader.addFont(Future.value(ByteData.view(fontBytes.buffer)));
            await fontLoader.load();
          }
        }
        await _appPrefs.setFontType(fontType.index);
      }

      final themeMode = settingsData['themeMode'] as int?;
      if (themeMode != null) await _appPrefs.setThemeMode(themeMode);

      final manualTheme = settingsData['manualTheme'] as int?;
      if (manualTheme != null) await _appPrefs.setManualTheme(manualTheme);
    }
  }
}

abstract class BackupAndRestoreViewModelInputs {
  Future<void> backupData();
  Future<void> restoreData();
}
