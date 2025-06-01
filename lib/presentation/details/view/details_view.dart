import 'package:flutter/material.dart';
import 'package:noted/app/constants.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/resources/values_manager.dart';
import 'package:noted/presentation/details/viewModel/details_viewmodel.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';

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
  int currentPage = 0;

  void _bind() {
    _viewModel.start();
    _viewModel.loadItemDetails(widget.id, widget.category);
  }

  @override
  void initState() {
    super.initState();
    _bind();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (_pageController.hasClients && _pageController.page != null) {
      if (mounted) {
        setState(() {
          currentPage = _pageController.page!.round();
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, int imageIndex) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: AppPadding.p4),
      width: currentPage == imageIndex ? 20.0 : 10.0,
      height: 8.0,
      decoration: BoxDecoration(
        color:
            currentPage == imageIndex
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,

      appBar: AppBar(
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          t.details.title,
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSize.s20),
          ),
        ),
        child: StateFlowHandler(
          stream: _viewModel.outputState,
          retryAction: () {
            _viewModel.loadItemDetails(widget.id, widget.category);
          },
          contentBuilder: (context) => _getContentWidget(),
        ),
      ),
    );
  }

  Widget buildInfoCard(BuildContext context, String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppSize.s18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            content,
            style: TextStyle(
              fontSize: AppSize.s16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: StreamBuilder<Details>(
        stream: _viewModel.outputItemDetails,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No details available'));
          }
          final details = snapshot.data!;

          if (details.imageUrls.isNotEmpty &&
              currentPage >= details.imageUrls.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _pageController.hasClients) {
                setState(() {
                  currentPage = 0;
                });
                _pageController.jumpToPage(0);
              }
            });
          } else if (details.imageUrls.isEmpty) {
            currentPage = 0;
          }

          return Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(details.imageUrls),
                const SizedBox(height: AppSize.s16),
                Text(
                  details.title,
                  style: const TextStyle(
                    fontSize: AppSize.s24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSize.s8),
                Text(
                  details.category.localizedCategory(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (details.description != null &&
                    details.description!.isNotEmpty) ...[
                  const SizedBox(height: AppSize.s8),
                  buildInfoCard(
                    context,
                    t.details.description,
                    details.description ?? Constants.empty,
                  ),
                ],

                if (details.platforms != null &&
                    details.platforms!.isNotEmpty) ...[
                  const SizedBox(height: AppSize.s16),
                  buildInfoCard(
                    context,
                    t.details.platforms,
                    details.platforms?.join(', ') ?? Constants.empty,
                  ),
                ],
                if (details.releaseDate != null &&
                    details.releaseDate!.isNotEmpty) ...[
                  const SizedBox(height: AppSize.s16),
                  buildInfoCard(
                    context,
                    t.details.releaseDate,
                    details.releaseDate ?? Constants.empty,
                  ),
                ],

                if (details.rating != null) ...[
                  const SizedBox(height: AppSize.s16),
                  buildInfoCard(
                    context,
                    t.details.rating,
                    details.rating.toString(),
                  ),
                ],

                if (details.publisher != null &&
                    details.publisher!.isNotEmpty) ...[
                  const SizedBox(height: AppSize.s16),
                  buildInfoCard(
                    context,
                    getPublisherLabel(details.category),
                    details.publisher ?? Constants.empty,
                  ),
                ],
              ],
            ),
          );
        },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final double galleryHeight = AppSize.s200;

    if (imageUrls.isEmpty) {
      return Container(
        height: galleryHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(
            screenWidth > 600 ? AppSize.s20 : AppSize.s12,
          ),
        ),
        child: Icon(
          Icons.image_not_supported_outlined,
          size: screenWidth > 600 ? AppSize.s80 : AppSize.s50,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
        ),
      );
    }

    return SizedBox(
      height: galleryHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth > 600 ? AppPadding.p16 : AppPadding.p8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    screenWidth > 600 ? AppSize.s20 : AppSize.s12,
                  ),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.1),
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: AppSize.s50,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.7),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // Page indicators
          if (imageUrls.length > 1)
            Positioned(
              bottom: AppPadding.p8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: () {
                  const int maxVisibleIndicators = 5;
                  final int totalImages = imageUrls.length;
                  List<Widget> indicators = [];

                  if (totalImages <= maxVisibleIndicators) {
                    for (int i = 0; i < totalImages; i++) {
                      indicators.add(_buildIndicator(context, i));
                    }
                  } else {
                    int start = currentPage - (maxVisibleIndicators ~/ 2);
                    int end = start + maxVisibleIndicators - 1;

                    if (start < 0) {
                      start = 0;
                      end = maxVisibleIndicators - 1;
                    } else if (end >= totalImages) {
                      end = totalImages - 1;
                      start = end - maxVisibleIndicators + 1;
                    }

                    for (int i = start; i <= end; i++) {
                      if (i >= 0 && i < totalImages) {
                        indicators.add(_buildIndicator(context, i));
                      }
                    }
                  }
                  return indicators;
                }(),
              ),
            ),
        ],
      ),
    );
  }
}
