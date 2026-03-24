import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/widgets/empty_state_widget.dart';
import 'package:noted/presentation/common/widgets/item_tile.dart'; // <-- Added import
import 'package:noted/presentation/search/search_viewmodel.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final SearchViewModel viewModel = instance<SearchViewModel>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        viewModel.search(searchController.text, loadMore: true);
      }
    });
    _bind();
  }

  void _bind() {
    viewModel.start();
  }

  @override
  void dispose() {
    viewModel.dispose();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateFlowHandler(
      stream: viewModel.outputState,
      retryAction: () {
        viewModel.search(searchController.text);
      },
      contentBuilder: (context) => _getContentWidget(),
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
                  return EmptyStateWidget(
                    icon: Icons.search,
                    message: t.search.searchForSomething,
                  );
                } else if (results.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.search_off,
                    message: t.search.noResultsFound,
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    primary: false,
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
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          const SizedBox(width: 8),
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

  Widget _buildResultItem(SearchItem searchItem) {
    final item = Item(
      searchItem.id,
      searchItem.title,
      searchItem.category,
      searchItem.imageUrl,
      searchItem.releaseDate,
    );

    return ItemTile(
      item: item,
      currentList: null,
      showSeriesTracker: false,
      cardColor: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.zero,
      customTrailing: SizedBox(
        height: 105,
        child: searchItem.isLocallyAdded
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.check_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_rounded),
                    color: Theme.of(context).colorScheme.primary,
                    tooltip: t.home.addToTodo,
                    onPressed: () =>
                        viewModel.addItemToList(searchItem, ItemListType.todo),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border_rounded),
                    color: Theme.of(context).colorScheme.primary,
                    tooltip: t.home.addToSaved,
                    onPressed: () =>
                        viewModel.addItemToList(searchItem, ItemListType.saved),
                  ),
                ],
              ),
      ),
    );
  }
}
