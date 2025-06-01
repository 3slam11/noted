import 'dart:async';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class StatisticsViewModel extends BaseViewModel
    implements StatisticsViewModelInputs, StatisticsViewModelOutputs {
  final Repository _repository;

  StatisticsViewModel(this._repository);

  final BehaviorSubject<bool> _isCurrentMonthViewSubject =
      BehaviorSubject<bool>.seeded(true);
  final BehaviorSubject<StatisticsData?> _statisticsDataSubject =
      BehaviorSubject<StatisticsData?>.seeded(null);

  List<Item> _allHistoryItems = [];
  List<Item> _currentMonthFinishedItems = [];

  @override
  void start() {
    _loadDataAndProcess();
    _isCurrentMonthViewSubject.stream.listen((_) {
      // Ensure data is loaded before trying to re-process
      if (_currentMonthFinishedItems.isNotEmpty ||
          _allHistoryItems.isNotEmpty ||
          !_isCurrentMonthViewSubject.value) {
        _processAndEmitStatistics();
      }
    });
  }

  Future<void> _loadDataAndProcess() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );

    bool homeSuccess = false;
    bool historySuccess = false;
    String? errorMessage;

    final homeEither = await _repository.getHome();
    homeEither.fold(
      (failure) {
        _currentMonthFinishedItems = [];
        errorMessage = failure.message;
      },
      (mainObject) {
        _currentMonthFinishedItems = mainObject.mainData?.finished ?? [];
        homeSuccess = true;
      },
    );

    final historyEither = await _repository.getHistory();
    historyEither.fold(
      (failure) {
        _allHistoryItems = [];
        errorMessage ??= failure.message;
      },
      (historyItems) {
        _allHistoryItems = historyItems;
        historySuccess = true;
      },
    );

    if (homeSuccess && historySuccess) {
      inputState.add(ContentState());
      _processAndEmitStatistics();
    } else {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.fullScreenErrorState,
          message: errorMessage ?? "Failed to load statistics data",
        ),
      );
    }
  }

  void _processAndEmitStatistics() {
    if (_statisticsDataSubject.isClosed) return;

    final bool isCurrentMonth = _isCurrentMonthViewSubject.value;
    final List<Item> itemsToProcess = isCurrentMonth
        ? _currentMonthFinishedItems
        : [..._currentMonthFinishedItems, ..._allHistoryItems];

    final Map<Category, int> categoryCounts = _calculateCategoryCounts(
      itemsToProcess,
    );
    final int totalItems = itemsToProcess.length;

    _statisticsDataSubject.add(
      StatisticsData(
        totalItems: totalItems,
        categoryCounts: categoryCounts,
        isMonthly: isCurrentMonth,
      ),
    );
  }

  Map<Category, int> _calculateCategoryCounts(List<Item> items) {
    final counts = <Category, int>{};
    for (var item in items) {
      if (item.category != null && item.category != Category.all) {
        counts[item.category!] = (counts[item.category!] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  void dispose() {
    _isCurrentMonthViewSubject.close();
    _statisticsDataSubject.close();
    super.dispose();
  }

  // Inputs
  @override
  void toggleTimePeriod() {
    if (!_isCurrentMonthViewSubject.isClosed) {
      _isCurrentMonthViewSubject.add(!_isCurrentMonthViewSubject.value);
    }
  }

  // Outputs
  @override
  Stream<bool> get outputIsCurrentMonthView =>
      _isCurrentMonthViewSubject.stream;

  @override
  Stream<StatisticsData?> get outputStatisticsData =>
      _statisticsDataSubject.stream;
}

abstract class StatisticsViewModelInputs {
  void toggleTimePeriod();
}

abstract class StatisticsViewModelOutputs {
  Stream<bool> get outputIsCurrentMonthView;
  Stream<StatisticsData?> get outputStatisticsData;
}
