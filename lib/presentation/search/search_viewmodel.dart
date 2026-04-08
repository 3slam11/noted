import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/search_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class SearchViewModel extends BaseViewModel
    implements SearchViewModelInputs, SearchViewModelOutputs {
  final BehaviorSubject<List<SearchItem>> _searchResultsStreamController =
      BehaviorSubject<List<SearchItem>>();
  final BehaviorSubject<Category> _selectedCategoryStreamController =
      BehaviorSubject<Category>();

  final SearchUsecase _searchUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;

  SearchViewModel(this._searchUsecase, this._dataGlobalNotifier);

  Category _currentCategory = Category.movies;
  String _lastQuery = "";
  int _currentPage = 1;
  bool _isFetchingNextPage = false;
  bool _hasMorePages = true;

  @override
  void start() {
    inputSelectedCategory.add(Category.movies);
  }

  @override
  void dispose() {
    _searchResultsStreamController.close();
    _selectedCategoryStreamController.close();
    super.dispose();
  }

  @override
  Future<void> search(String query, {bool loadMore = false}) async {
    String trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      inputSearchResults.add([]);
      return;
    }

    if (loadMore) {
      if (_isFetchingNextPage || !_hasMorePages) return;
      _isFetchingNextPage = true;
      _currentPage++;
    } else {
      _lastQuery = trimmedQuery;
      _currentPage = 1;
      _hasMorePages = true;
      inputState.add(
        LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
        ),
      );
    }

    (await _searchUsecase.execute(
      SearchInput(trimmedQuery, _currentCategory, _currentPage),
    )).fold(
      (failure) {
        if (loadMore) {
          _currentPage--;
          _isFetchingNextPage = false;
        } else {
          inputState.add(
            ErrorState(
              stateRendererType: StateRendererType.fullScreenErrorState,
              message: failure.message,
            ),
          );
        }
      },
      (searchResults) {
        final newItems = searchResults.items ?? [];
        if (newItems.isEmpty) {
          _hasMorePages = false;
        }

        if (loadMore) {
          final currentItems = _searchResultsStreamController.valueOrNull ?? [];
          inputSearchResults.add([...currentItems, ...newItems]);
          _isFetchingNextPage = false;
        } else {
          inputState.add(ContentState());
          inputSearchResults.add(newItems);
        }
      },
    );
  }

  @override
  void updateCategory(Category category) {
    _currentCategory = category;
    inputSelectedCategory.add(category);
    if (_lastQuery.isNotEmpty) {
      search(_lastQuery);
    }
  }

  @override
  void addItemToList(SearchItem item, ItemListType listType) async {
    ItemResponse itemResponse = ItemResponse(
      item.id,
      item.title,
      item.category,
      item.imageUrl,
      item.releaseDate,
    );

    final result = listType == ItemListType.todo
        ? await _searchUsecase.addToTodo(itemResponse)
        : await _searchUsecase.addToSaved(itemResponse);

    result.fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: failure.message,
          ),
        );
      },
      (_) {
        _dataGlobalNotifier.notifyDataImported();

        final currentResults = _searchResultsStreamController.valueOrNull ?? [];
        final updatedResults = currentResults.map((searchItem) {
          if (searchItem.id == item.id &&
              searchItem.category == item.category) {
            return searchItem.copyWith(isLocallyAdded: true);
          }
          return searchItem;
        }).toList();

        inputSearchResults.add(updatedResults);
      },
    );
  }

  @override
  void addManualItem({
    required String title,
    required Category category,
    required ItemListType listType,
    String? description,
    String? posterUrl,
    List<String>? additionalImageUrls,
    String? releaseDate,
    List<String>? genres,
    String? publisher,
    List<String>? platforms,
  }) async {
    final id = 'manual_${DateTime.now().millisecondsSinceEpoch}';
    final itemResponse = ItemResponse(
      id,
      title,
      category,
      posterUrl,
      releaseDate,
      description: description,
      additionalImageUrls: additionalImageUrls,
      genres: genres,
      publisher: publisher,
      platforms: platforms,
      dateAdded: DateTime.now(),
    );

    Either<Failure, void> result;
    switch (listType) {
      case ItemListType.todo:
        result = await _searchUsecase.addToTodo(itemResponse);
        break;
      case ItemListType.finished:
        result = await _searchUsecase.addToFinished(itemResponse);
        break;
      case ItemListType.saved:
        result = await _searchUsecase.addToSaved(itemResponse);
        break;
      case ItemListType.history:
        result = await _searchUsecase.addToHistory(itemResponse);
        break;
    }

    result.fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: failure.message,
          ),
        );
      },
      (_) {
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  // Inputs
  @override
  Sink<List<SearchItem>> get inputSearchResults =>
      _searchResultsStreamController.sink;
  @override
  Sink<Category> get inputSelectedCategory =>
      _selectedCategoryStreamController.sink;
  // Outputs
  @override
  Stream<List<SearchItem>> get outputSearchResults =>
      _searchResultsStreamController.stream;
  @override
  Stream<Category> get outputSelectedCategory =>
      _selectedCategoryStreamController.stream;
}

abstract class SearchViewModelInputs {
  Sink<List<SearchItem>> get inputSearchResults;
  Sink<Category> get inputSelectedCategory;
  Future<void> search(String query, {bool loadMore = false});
  void updateCategory(Category category);
  void addItemToList(SearchItem item, ItemListType listType);
  void addManualItem({
    required String title,
    required Category category,
    required ItemListType listType,
    String? description,
    String? posterUrl,
    List<String>? additionalImageUrls,
    String? releaseDate,
    List<String>? genres,
    String? publisher,
    List<String>? platforms,
  });
}

abstract class SearchViewModelOutputs {
  Stream<List<SearchItem>> get outputSearchResults;
  Stream<Category> get outputSelectedCategory;
}
