import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/resources/values_manager.dart';
import 'package:noted/presentation/details/viewModel/details_viewmodel.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsView extends StatefulWidget {
  final String id;
  final Category category;

  const DetailsView({super.key, required this.id, required this.category});

  @override
  DetailsViewState createState() => DetailsViewState();
}

class DetailsViewState extends State<DetailsView> {
  final DetailsViewModel _viewModel = instance<DetailsViewModel>();
  late final PageController _pageController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _viewModel.start();
    _viewModel.loadItemDetails(widget.id, widget.category);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          t.details.title,
          style: theme.appBarTheme.titleTextStyle?.copyWith(fontSize: 23),
        ),
      ),
      body: StateFlowHandler(
        stream: _viewModel.outputState,
        retryAction: () =>
            _viewModel.loadItemDetails(widget.id, widget.category),
        contentBuilder: (context) => _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: StreamBuilder<Details>(
        stream: _viewModel.outputItemDetails,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final details = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(details.imageUrls)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: AppSize.s16),
                Text(
                  details.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                const SizedBox(height: AppSize.s8),
                Text(
                  details.category.localizedCategory(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                _buildSeriesTracker(
                  details,
                ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
                if (details.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSize.s16),
                  InfoCard(
                    title: t.details.description,
                    content: details.description!,
                  ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                ],
                if (details.genres?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSize.s16),
                  _buildGenresSection(
                    details.genres!,
                  ).animate(delay: 450.ms).fadeIn(duration: 400.ms),
                ],
                if (details.platforms?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSize.s16),
                  InfoCard(
                    title: t.details.platforms,
                    content: details.platforms!.join(', '),
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
                ],
                if (details.releaseDate?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSize.s16),
                  InfoCard(
                    title: t.details.releaseDate,
                    content: details.releaseDate!,
                  ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
                ],
                if (details.rating != null) ...[
                  const SizedBox(height: AppSize.s16),
                  InfoCard(
                    title: t.details.rating,
                    content: details.rating.toString(),
                  ).animate(delay: 700.ms).fadeIn(duration: 400.ms),
                ],
                if (details.publisher?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSize.s16),
                  InfoCard(
                    title: getPublisherLabel(details.category),
                    content: details.publisher!,
                  ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
                ],
                const SizedBox(height: AppSize.s24),
                _buildRecommendationsSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeriesTracker(Details details) {
    if (details.category != Category.series ||
        (details.numberOfSeasons ?? 0) == 0) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<Item?>(
      stream: _viewModel.outputLocalItem,
      builder: (context, snapshot) {
        final localItem = snapshot.data;
        if (localItem == null) {
          return const SizedBox.shrink();
        }
        return _SeriesTracker(
          details: details,
          localItem: localItem,
          viewModel: _viewModel,
        );
      },
    );
  }

  Widget _buildGenresSection(List<String> genres) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withAlpha(20),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.details.genres,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: genres.map((genre) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  genre,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withAlpha(25),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.details.moreLikeThis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 900.ms),
          const SizedBox(height: AppSize.s12),
          StreamBuilder<FlowState>(
            stream: _viewModel.outputRecommendationsState,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ErrorState) {
                return Center(child: Text(state.message));
              }
              return _buildRecommendationsList();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return StreamBuilder<List<SearchItem>>(
      stream: _viewModel.outputRecommendations,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p20),
              child: Text(t.details.noRecommendations),
            ),
          );
        }
        final recommendations = snapshot.data!;
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              return _buildRecommendationCard(recommendations[index])
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                  .slideX(begin: 0.5, end: 0);
            },
          ),
        );
      },
    );
  }

  Widget _buildRecommendationCard(SearchItem item) {
    return SizedBox(
      width: 140,
      child: Card(
        margin: const EdgeInsets.only(right: AppPadding.p12),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutesManager.detailsRoute,
              arguments: DetailsView(id: item.id, category: item.category),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 40),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          );
                        },
                      )
                    : const Icon(Icons.image_not_supported, size: 40),
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getPublisherLabel(Category category) {
    switch (category) {
      case Category.movies:
      case Category.series:
        return t.details.network;
      case Category.books:
        return t.details.publisher;
      case Category.games:
        return t.details.studio;
      case Category.all:
        return t.details.series;
    }
  }

  Widget _buildImageGallery(List<String> imageUrls) {
    final theme = Theme.of(context);
    final deviceWidth = MediaQuery.of(context).size.width;

    if (imageUrls.isEmpty) {
      return Container(
        height: AppSize.s200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withAlpha(25),
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Icon(
          Icons.image_not_supported_outlined,
          size: AppSize.s50,
          color: theme.colorScheme.primary.withAlpha(128),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: SizedBox(
        height: AppSize.s200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s12),
                    child: Image.network(
                      imageUrls[index],
                      fit: deviceWidth > 500 ? BoxFit.contain : BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.secondary.withAlpha(15),
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: AppSize.s50,
                            color: theme.colorScheme.primary.withAlpha(128),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            if (imageUrls.length > 1)
              Positioned(
                bottom: AppPadding.p8,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: imageUrls.length > 5 ? 5 : imageUrls.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: theme.colorScheme.primary,
                    dotColor: Colors.white.withAlpha(128),
                  ),
                ),
              ),
            if (_isHovering && imageUrls.length > 1) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: _NavigationArrow(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _NavigationArrow(
                  icon: Icons.arrow_forward_ios_rounded,
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavigationArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavigationArrow({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        tooltip: 'Navigate images',
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? child;

  const InfoCard({super.key, required this.title, this.content, this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withAlpha(25),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          if (content != null) Text(content!, style: theme.textTheme.bodyLarge),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _SeriesTracker extends StatefulWidget {
  final Details details;
  final Item localItem;
  final DetailsViewModel viewModel;

  const _SeriesTracker({
    required this.details,
    required this.localItem,
    required this.viewModel,
  });

  @override
  State<_SeriesTracker> createState() => _SeriesTrackerState();
}

class _SeriesTrackerState extends State<_SeriesTracker> {
  int? _selectedSeason;
  int? _selectedEpisode;
  int _episodeCountForSelectedSeason = 0;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  @override
  void didUpdateWidget(covariant _SeriesTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.localItem.currentSeason != _selectedSeason ||
        widget.localItem.currentEpisode != _selectedEpisode) {
      _initializeState();
    }
  }

  void _initializeState() {
    _selectedSeason = widget.localItem.currentSeason;
    _selectedEpisode = widget.localItem.currentEpisode;
    _updateEpisodeCount();
  }

  void _updateEpisodeCount() {
    if (_selectedSeason != null && widget.details.seasons != null) {
      final seasonInfo = widget.details.seasons!.firstWhere(
        (s) => s.seasonNumber == _selectedSeason,
        orElse: () => SeasonInfo(seasonNumber: 0, episodeCount: 0),
      );
      _episodeCountForSelectedSeason = seasonInfo.episodeCount;
    } else {
      _episodeCountForSelectedSeason = 0;
    }
  }

  double get _progressPercentage {
    if (_selectedSeason == null || _selectedEpisode == null) return 0.0;

    final seasons = widget.details.seasons;
    if (seasons == null || seasons.isEmpty) return 0.0;

    // calculate total episodes watched (completed seasons + current season progress)
    int totalEpisodesWatched = 0;

    // add episodes from completed seasons (seasons before current)
    for (final season in seasons) {
      if (season.seasonNumber < _selectedSeason!) {
        totalEpisodesWatched += season.episodeCount;
      }
    }

    // add current season progress
    totalEpisodesWatched += _selectedEpisode!;

    // calculate total episodes in entire series
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

    return Padding(
      padding: const EdgeInsets.only(top: AppSize.s16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withAlpha(25),
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tv_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSize.s8),
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
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(_progressPercentage * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s12),

            // Progress Bar
            Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: theme.colorScheme.outline.withAlpha(30),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s16),

            // Dropdowns Row
            Row(
              children: [
                Expanded(
                  child: _buildStyledDropdown(
                    label: t.details.season,
                    icon: Icons.calendar_view_month_rounded,
                    value: _selectedSeason,
                    items: seasons.map((s) => s.seasonNumber).toList(),
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
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: _buildStyledDropdown(
                    label: t.details.episode,
                    icon: Icons.play_circle_outline_rounded,
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSize.s12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
      ),
      child: DropdownButtonFormField<int>(
        initialValue: value,
        items: items.map((number) {
          return DropdownMenuItem<int>(
            value: number,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: AppSize.s8),
                Text(
                  '$number',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p12,
            vertical: AppPadding.p8,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        dropdownColor: theme.colorScheme.surface,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.colorScheme.primary,
        ),
        isExpanded: true,
      ),
    );
  }
}
