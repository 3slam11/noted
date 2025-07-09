import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/data/data_source/local_data_source.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class BackupAndRestoreViewModel extends BaseViewModel
    implements BackupAndRestoreViewModelInputs {
  final LocalDataSource _localDataSource;
  final AppPrefs _appPrefs;
  final ThemeManager _themeManager;
  final DataGlobalNotifier _dataGlobalNotifier;

  BackupAndRestoreViewModel(
    this._localDataSource,
    this._appPrefs,
    this._themeManager,
    this._dataGlobalNotifier,
  );

  @override
  void start() {}

  @override
  Future<void> backupData() async {
    try {
      // 1. Get Lists
      final todos = await _localDataSource.getTodo();
      final finished = await _localDataSource.getFinished();
      final history = await _localDataSource.getHistory();

      // 2. Get Settings
      final language = await _appPrefs.getLanguage();
      final themeMode = await _appPrefs.getThemeMode();
      final manualTheme = await _appPrefs.getManualTheme();
      final rawgKey = await _appPrefs.getCustomRawgApiKey();
      final tmdbKey = await _appPrefs.getCustomTmdbApiKey();
      final booksKey = await _appPrefs.getCustomBooksApiKey();
      final fontType = await _appPrefs.getFontType();

      String? customFontBase64;
      String? fontFamilyName;
      if (fontType == FontType.custom.index) {
        final fontPath = await _appPrefs.getCustomFontPath();
        fontFamilyName = await _appPrefs.getCustomFontFamilyName();
        if (fontPath.isNotEmpty && File(fontPath).existsSync()) {
          final fontBytes = await File(fontPath).readAsBytes();
          customFontBase64 = base64Encode(fontBytes);
        }
      }

      // 3. Assemble backup data with versioning
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

      // 4. Save file
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

      final fileBytes = result!.files.single.bytes!;
      final String jsonData = utf8.decode(fileBytes);
      final Map<String, dynamic> backupData = jsonDecode(jsonData);

      await _restore(backupData);

      // Notify app of changes
      _themeManager.notifyThemeChange();
      _dataGlobalNotifier.notifyDataImported();
    } catch (e) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: '${t.backupAndRestore.restoreFailed}${e.toString()}',
        ),
      );
    }
  }

  Future<void> _restore(Map<String, dynamic> backupData) async {
    // 1. Restore Lists
    await _localDataSource.clearTodo();
    await _localDataSource.clearFinished();
    await _localDataSource.clearHistory();

    final Map<String, dynamic>? listsData =
        backupData['lists'] as Map<String, dynamic>?;

    if (listsData != null) {
      // Restore todos
      final List<dynamic> todosData = listsData['todos'] ?? [];
      for (var itemData in todosData) {
        await _localDataSource.addTodo(
          ItemResponse.fromJson(itemData as Map<String, dynamic>),
        );
      }

      // Restore finished
      final List<dynamic> finishedData = listsData['finished'] ?? [];
      for (var itemData in finishedData) {
        await _localDataSource.addFinished(
          ItemResponse.fromJson(itemData as Map<String, dynamic>),
        );
      }

      // Restore history
      final List<dynamic> historyData = listsData['history'] ?? [];
      for (var itemData in historyData) {
        await _localDataSource.addHistory(
          ItemResponse.fromJson(itemData as Map<String, dynamic>),
        );
      }
    }

    // 2. Restore Settings
    final Map<String, dynamic>? settingsData =
        backupData['settings'] as Map<String, dynamic>?;

    if (settingsData != null) {
      // Language
      final lang = settingsData['language'] as String?;
      if (lang != null) {
        await _appPrefs.setLanguage(lang);
        LocaleSettings.setLocaleRaw(lang);
      }

      // API Keys
      await _appPrefs.setCustomRawgApiKey(
        settingsData['rawgKey'] as String? ?? '',
      );
      await _appPrefs.setCustomTmdbApiKey(
        settingsData['tmdbKey'] as String? ?? '',
      );
      await _appPrefs.setCustomBooksApiKey(
        settingsData['booksKey'] as String? ?? '',
      );

      // Font
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
            // Use a unique name to avoid conflicts
            final newPath = p.join(
              fontDir.path,
              '${fontFamilyName}_${DateTime.now().millisecondsSinceEpoch}.ttf',
            );
            final newFile = File(newPath);
            await newFile.writeAsBytes(fontBytes);

            await _appPrefs.setCustomFontPath(newPath);
            await _appPrefs.setCustomFontFamilyName(fontFamilyName);

            final fontLoader = FontLoader(fontFamilyName);
            fontLoader.addFont(Future.value(ByteData.view(fontBytes.buffer)));
            await fontLoader.load();
          }
        }
        await _appPrefs.setFontType(fontType.index);
      }

      // Theme
      final themeMode = settingsData['themeMode'] as int?;
      final manualTheme = settingsData['manualTheme'] as int?;
      if (themeMode != null) {
        await _appPrefs.setThemeMode(themeMode);
      }
      if (manualTheme != null) {
        await _appPrefs.setManualTheme(manualTheme);
      }
    }
  }
}

abstract class BackupAndRestoreViewModelInputs {
  Future<void> backupData();
  Future<void> restoreData();
}
