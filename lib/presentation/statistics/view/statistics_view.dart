import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/statistics/viewModel/statistics_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  StatisticsViewState createState() => StatisticsViewState();
}

class StatisticsViewState extends State<StatisticsView> {
  final StatisticsViewModel _viewModel = instance<StatisticsViewModel>();

  final Map<Category, Color> categoryColors = {
    Category.movies: Colors.blue,
    Category.books: Colors.green,
    Category.games: Colors.purple,
    Category.series: Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    _viewModel.start();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Widget _buildSummaryCard(String title, String value) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<Category, int> categoryCounts) {
    final total = categoryCounts.values.fold(
      0,
      (totalSum, totalCount) => totalSum + totalCount,
    );

    if (total == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            t.statistics.noData,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      );
    }

    final sections = categoryCounts.entries.map((entry) {
      final percentage = (entry.value / total * 100).roundToDouble();
      return PieChartSectionData(
        color:
            categoryColors[entry.key]?.withValues(alpha: 0.8) ??
            Theme.of(context).colorScheme.primary,
        value: entry.value.toDouble(),
        title: '${percentage.round()}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildCategoryLegend(Map<Category, int> categoryCounts) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categoryCounts.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                categoryColors[entry.key]?.withValues(alpha: 0.15) ??
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color:
                      categoryColors[entry.key] ??
                      Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${entry.key.localizedCategory()}: ${entry.value}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<StatisticsData?>(
      stream: _viewModel.outputStatisticsData,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          // This case should ideally be handled by StateFlowHandler's loading state
          // or show a specific "no data yet" message if ContentState is emitted with null data.
          return Center(child: Text(t.statistics.noData));
        }

        final statsData = snapshot.data!;
        final categoryCounts = statsData.categoryCounts;
        final totalItems = statsData.totalItems;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time period selector
              StreamBuilder<bool>(
                stream: _viewModel.outputIsCurrentMonthView,
                builder: (context, isCurrentMonthSnapshot) {
                  final bool showCurrentMonth =
                      isCurrentMonthSnapshot.data ?? true;
                  return Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if (!showCurrentMonth) {
                                  _viewModel.toggleTimePeriod();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  showCurrentMonth
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                t.statistics.thisMonth,
                                style: TextStyle(
                                  color: showCurrentMonth
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if (showCurrentMonth) {
                                  _viewModel.toggleTimePeriod();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  !showCurrentMonth
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                t.statistics.allTime,
                                style: TextStyle(
                                  color: !showCurrentMonth
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      t.statistics.totalItems,
                      totalItems.toString(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      t.statistics.category,
                      categoryCounts.length.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Category distribution
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      if (totalItems > 0) ...[
                        _buildPieChart(categoryCounts),
                        const SizedBox(height: 16),
                        _buildCategoryLegend(categoryCounts),
                      ] else
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.list_alt,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  t.statistics.noData,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
          t
              .settings
              .statistics, // Using the string from settings for consistency
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: StateFlowHandler(
        stream: _viewModel.outputState,
        retryAction: () {
          _viewModel.start(); // Or a specific retry method if needed
        },
        contentBuilder: (context) => _getContentWidget(),
      ),
    );
  }
}
