import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/data/data_source/local_data_source.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';

class BackupAndRestoreViewModel extends BaseViewModel
    implements
        BackupAndRestoreViewModelInputs,
        BackupAndRestoreViewModelOutputs {
  final LocalDataSource _localDataSource;
  final DataGlobalNotifier _dataGlobalNotifier;

  BackupAndRestoreViewModel(this._localDataSource, this._dataGlobalNotifier);

  @override
  void start() {}

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

        if (backupData.containsKey('todos') &&
            backupData.containsKey('finished') &&
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
}

abstract class BackupAndRestoreViewModelOutputs {
  // OutputState is inherited from BaseViewModel
}
