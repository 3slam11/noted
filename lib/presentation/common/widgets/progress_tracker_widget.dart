import 'package:flutter/material.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/details/details_viewmodel.dart';
import 'package:noted/presentation/resources/values_manager.dart';

class ProgressTrackerWidget extends StatefulWidget {
  final Details details;
  final Item localItem;
  final DetailsViewModel viewModel;

  const ProgressTrackerWidget({
    super.key,
    required this.details,
    required this.localItem,
    required this.viewModel,
  });

  @override
  State<ProgressTrackerWidget> createState() => _ProgressTrackerWidgetState();
}

class _ProgressTrackerWidgetState extends State<ProgressTrackerWidget> {
  int? _selectedSeason;
  int? _selectedEpisode;
  int _episodeCountForSelectedSeason = 0;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  @override
  void didUpdateWidget(covariant ProgressTrackerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.localItem.currentSeason != widget.localItem.currentSeason ||
        oldWidget.localItem.currentEpisode != widget.localItem.currentEpisode) {
      _initializeState();
    }
  }

  void _initializeState() {
    _selectedSeason = widget.localItem.currentSeason ?? 1;
    _selectedEpisode = widget.localItem.currentEpisode ?? 1;
    _updateEpisodeCount();
  }

  void _updateEpisodeCount() {
    if (_selectedSeason != null && widget.details.seasons != null) {
      final seasonInfo = widget.details.seasons!.firstWhere(
        (s) => s.seasonNumber == _selectedSeason,
        orElse: () =>
            SeasonInfo(seasonNumber: _selectedSeason!, episodeCount: 0),
      );
      _episodeCountForSelectedSeason = seasonInfo.episodeCount;
    } else {
      _episodeCountForSelectedSeason = 0;
    }

    // Fallback for ongoing series (API returned 0 or null)
    // Allows the user to select up to 50 episodes ahead of their current progress
    if (_episodeCountForSelectedSeason <= 0) {
      _episodeCountForSelectedSeason = (_selectedEpisode ?? 1) + 50;
    }
  }

  bool get _isOngoing {
    final seasons = widget.details.seasons;
    if (seasons == null || seasons.isEmpty) return true;
    final total = seasons.fold<int>(
      0,
      (sum, season) => sum + season.episodeCount,
    );
    return total == 0;
  }

  double get _progressPercentage {
    if (_selectedSeason == null || _selectedEpisode == null) return 0.0;
    if (_isOngoing) return 0.0;

    final seasons = widget.details.seasons!;
    int totalEpisodesWatched = 0;

    for (final season in seasons) {
      if (season.seasonNumber < _selectedSeason!) {
        totalEpisodesWatched += season.episodeCount;
      }
    }

    totalEpisodesWatched += _selectedEpisode!;

    final totalEpisodesInSeries = seasons.fold<int>(
      0,
      (sum, season) => sum + season.episodeCount,
    );

    if (totalEpisodesInSeries == 0) return 0.0;

    return (totalEpisodesWatched / totalEpisodesInSeries).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final seasons = widget.details.seasons ?? [];

    // Ensure we have season items even if API returned empty or missing seasons
    List<int> seasonItems = seasons.map((s) => s.seasonNumber).toList();
    if (seasonItems.isEmpty) {
      seasonItems = List.generate((_selectedSeason ?? 1), (i) => i + 1);
    } else if (_selectedSeason != null &&
        !seasonItems.contains(_selectedSeason)) {
      seasonItems.add(_selectedSeason!);
      seasonItems.sort();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSize.s16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.p20),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withAlpha(25),
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.movie_filter_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Text(
                  t.details.progressTracker,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isOngoing
                        ? 'Ongoing'
                        : '${(_progressPercentage * 100).toInt()}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s20),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 8,
                width: double.infinity,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                child: FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: _isOngoing ? 1.0 : _progressPercentage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _isOngoing
                          ? theme.colorScheme.primary.withValues(alpha: 0.5)
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s24),

            // Dropdowns Row
            Row(
              children: [
                Expanded(
                  child: _buildStyledDropdown(
                    label: t.details.season,
                    icon: Icons.auto_awesome_motion_rounded,
                    value: _selectedSeason,
                    items: seasonItems,
                    onChanged: (newSeason) {
                      if (newSeason == null) return;
                      setState(() {
                        _selectedSeason = newSeason;
                        _selectedEpisode = 1;
                        _updateEpisodeCount();
                      });
                      widget.viewModel.updateTracking(
                        season: _selectedSeason,
                        episode: _selectedEpisode,
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                Expanded(
                  child: _buildStyledDropdown(
                    label: t.details.episode,
                    icon: Icons.play_circle_fill_rounded,
                    value: _selectedEpisode,
                    items: List.generate(
                      _episodeCountForSelectedSeason,
                      (i) => i + 1,
                    ),
                    onChanged: (newEpisode) {
                      if (newEpisode == null) return;
                      setState(() {
                        _selectedEpisode = newEpisode;
                      });
                      widget.viewModel.updateTracking(
                        season: _selectedSeason,
                        episode: _selectedEpisode,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledDropdown({
    required String label,
    required IconData icon,
    required int? value,
    required List<int> items,
    required ValueChanged<int?> onChanged,
  }) {
    final theme = Theme.of(context);

    // Ensure the value exists in the items list to prevent DropdownButton assertion errors
    if (value != null && !items.contains(value)) {
      items.add(value);
      items.sort();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: value,
              icon: Icon(
                Icons.unfold_more_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              dropdownColor: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              items: items.map((number) {
                return DropdownMenuItem<int>(
                  value: number,
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        '$number',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
