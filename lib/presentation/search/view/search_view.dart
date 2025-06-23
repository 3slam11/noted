import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';
import 'package:noted/presentation/search/viewModel/search_viewmodel.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/details/view/details_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  late final SearchViewModel viewModel = instance<SearchViewModel>();

  @override
  void initState() {
    super.initState();
    _bind();
  }

  void _bind() {
    viewModel.start();
  }

  @override
  void dispose() {
    viewModel.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          t.search.search,
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: StateFlowHandler(
        stream: viewModel.outputState,
        retryAction: () {
          viewModel.search(searchController.text);
        },
        contentBuilder: (context) => _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<SearchItem>>(
              stream: viewModel.outputSearchResults,
              builder: (context, snapshot) {
                final results = snapshot.data;
                if (results == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                              Icons.search,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .scale(begin: const Offset(0.5, 0.5))
                            .then()
                            .shake(duration: 500.ms, delay: 1000.ms),
                        const SizedBox(height: 16),
                        Text(
                              t.search.searchForSomething,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .scale(begin: const Offset(0.5, 0.5)),
                      ],
                    ),
                  );
                } else if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                              Icons.search_off,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .scale(begin: const Offset(0.5, 0.5))
                            .then()
                            .shake(duration: 500.ms, delay: 1000.ms),
                        const SizedBox(height: 16),
                        Text(
                              t.search.noResultsFound,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 200.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildResultItem(
                          results[index],
                        ).animate().fadeIn(duration: 300.ms),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: t.search.searchPlaceholder,
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => viewModel.search(searchController.text),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              onSubmitted: (query) => viewModel.search(query),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder<Category>(
              stream: viewModel.outputSelectedCategory,
              builder: (context, snapshot) {
                final selectedCategory = snapshot.data ?? Category.movies;
                return DropdownButton<Category>(
                  value: selectedCategory,
                  underline: Container(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  onChanged: (Category? newValue) {
                    if (newValue != null) {
                      viewModel.updateCategory(newValue);
                    }
                  },
                  items: Category.values
                      .where((category) => category != Category.all)
                      .map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.localizedCategory(),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        );
                      })
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -1, end: 0);
  }

  Widget _buildResultItem(SearchItem item) {
    bool isAdded = item.isLocallyAdded;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesManager.detailsRoute,
            arguments: DetailsView(id: item.id, category: item.category),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s8),
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        width: AppSize.s80,
                        height: AppSize.s120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: AppSize.s80,
                            height: AppSize.s120,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported),
                          );
                        },
                      )
                    : Container(
                        width: AppSize.s80,
                        height: AppSize.s120,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported),
                      ),
              ),
              const SizedBox(width: AppSize.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: AppSize.s16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.releaseDate != null &&
                        item.releaseDate!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p8),
                        child: Text(
                          '${item.releaseDate}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isAdded ? Icons.check_circle_outline : Icons.add_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: isAdded
                    ? null
                    : () {
                        viewModel.addItemToTodo(item);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
