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

class DetailsView extends StatefulWidget {
  final String id;
  final Category category;

  const DetailsView({super.key, required this.id, required this.category});

  @override
  DetailsViewState createState() => DetailsViewState();
}

class DetailsViewState extends State<DetailsView> {
  final DetailsViewModel _viewModel = instance<DetailsViewModel>();
  late PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _viewModel.start();
    _viewModel.loadItemDetails(widget.id, widget.category);

    _pageController = PageController();
    _currentPageNotifier = ValueNotifier<int>(0);

    _pageController.addListener(() {
      if (_pageController.hasClients && _pageController.page != null) {
        _currentPageNotifier.value = _pageController.page!.round();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
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
            return const Center(child: Text('No details available'));
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
                if (details.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSize.s16),
                  InfoCard(
                    title: t.details.description,
                    content: details.description!,
                  ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
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

  Widget _buildRecommendationsSection() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.s12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.details.moreLikeThis,
            style: theme.textTheme.titleMedium?.copyWith(
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
          color: theme.colorScheme.secondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Icon(
          Icons.image_not_supported_outlined,
          size: AppSize.s50,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
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
                          color: theme.colorScheme.secondary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: AppSize.s50,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.7,
                            ),
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
                child: ImageGalleryIndicator(
                  pageController: _pageController,
                  pageNotifier: _currentPageNotifier,
                  imageCount: imageUrls.length,
                ),
              ),
            if (_isHovering && imageUrls.length > 1) ...[
              // Previous Button
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
              // Next Button
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
        color: Colors.black.withValues(alpha: 0.4),
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
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.s12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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
          Text(content, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class ImageGalleryIndicator extends StatelessWidget {
  final PageController pageController;
  final ValueNotifier<int> pageNotifier;
  final int imageCount;

  const ImageGalleryIndicator({
    super.key,
    required this.pageController,
    required this.pageNotifier,
    required this.imageCount,
  });

  @override
  Widget build(BuildContext context) {
    if (imageCount <= 1) return const SizedBox.shrink();

    return ValueListenableBuilder<int>(
      valueListenable: pageNotifier,
      builder: (context, currentPage, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildSlidingDots(context, currentPage),
        );
      },
    );
  }

  List<Widget> _buildSlidingDots(BuildContext context, int currentPage) {
    List<Widget> dots = [];

    int dotsToShow = imageCount >= 3 ? 3 : imageCount;

    for (int i = 0; i < dotsToShow; i++) {
      int dotIndex;
      bool isActive = false;

      if (imageCount <= 3) {
        dotIndex = i;
        isActive = (i == currentPage);
      } else {
        if (currentPage == 0) {
          dotIndex = i;
          isActive = (i == 0);
        } else if (currentPage == imageCount - 1) {
          dotIndex = imageCount - 3 + i;
          isActive = (i == 2);
        } else {
          dotIndex = currentPage - 1 + i;
          isActive = (i == 1);
        }
      }

      dots.add(
        Animate(
          key: ValueKey(dotIndex),
          effects: [
            FadeEffect(
              duration: const Duration(milliseconds: 500),
              begin: dotIndex == currentPage ? 0.3 : 1.0,
              end: dotIndex == currentPage ? 1.0 : 0.3,
              curve: Curves.easeInOut,
            ),
            SlideEffect(
              duration: const Duration(milliseconds: 500),
              begin: dotIndex < currentPage
                  ? const Offset(-0.3, 0)
                  : const Offset(0.3, 0),
              end: const Offset(0, 0),
              curve: Curves.easeInOut,
            ),
          ],
          child: _buildDot(context, isActive),
        ),
      );

      // Add spacing between dots
      if (i < dotsToShow - 1) {
        dots.add(const SizedBox(width: 8));
      }
    }

    return dots;
  }

  Widget _buildDot(BuildContext context, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? 20.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
