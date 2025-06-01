import 'dart:async';
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
  final BehaviorSubject<bool> _itemAddedSuccessfullyStreamController =
      BehaviorSubject<bool>();

  final SearchUsecase searchUsecase;
  SearchViewModel(this.searchUsecase);
  Category _currentCategory = Category.movies;
  String lastQuery = "";
  @override
  void start() {
    inputSelectedCategory.add(Category.movies);
  }

  @override
  void dispose() {
    _searchResultsStreamController.close();
    _selectedCategoryStreamController.close();
    _itemAddedSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  Future<void> search(String query) async {
    String trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      inputSearchResults.add([]);
      return;
    }
    lastQuery = trimmedQuery;

    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );

    (await searchUsecase.execute(
      SearchInput(trimmedQuery, _currentCategory),
    )).fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.fullScreenErrorState,
            message: failure.message,
          ),
        );
      },
      (searchResults) {
        inputState.add(ContentState());
        inputSearchResults.add(searchResults.items ?? []);
      },
    );
  }

  @override
  void updateCategory(Category category) {
    _currentCategory = category;
    inputSelectedCategory.add(category);
    if (lastQuery.isNotEmpty) {
      search(lastQuery);
    }
  }

  @override
  void addItemToTodo(SearchItem item) async {
    ItemResponse todoItem = ItemResponse(
      item.id,
      item.title,
      item.category,
      item.imageUrl,
      item.releaseDate,
    );

    (await searchUsecase.addToTodo(todoItem)).fold(
      (failure) {
        _itemAddedSuccessfullyStreamController.add(false);
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: failure.message,
          ),
        );
      },
      (_) {
        _itemAddedSuccessfullyStreamController.add(true);

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

  @override
  Stream<bool> get outputItemAddedSuccessfully =>
      _itemAddedSuccessfullyStreamController.stream;
}

abstract class SearchViewModelInputs {
  Sink<List<SearchItem>> get inputSearchResults;
  Sink<Category> get inputSelectedCategory;
  Future<void> search(String query);
  void updateCategory(Category category);
  void addItemToTodo(SearchItem item);
}

abstract class SearchViewModelOutputs {
  Stream<List<SearchItem>> get outputSearchResults;
  Stream<Category> get outputSelectedCategory;
  Stream<bool> get outputItemAddedSuccessfully;
}
