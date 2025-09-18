import 'package:json_annotation/json_annotation.dart';
import 'package:noted/app/constants.dart';
import 'package:noted/domain/model/models.dart';
part 'responses.g.dart';

class BaseResponse {
  @JsonKey(name: 'status')
  int? status;

  @JsonKey(name: 'message')
  String? message;
}

// main page responses
@JsonSerializable()
class ItemResponse {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'category')
  Category? category;

  @JsonKey(name: 'posterUrl')
  String? posterUrl;

  @JsonKey(name: 'releaseDate')
  String? releaseDate;

  @JsonKey(name: 'personalRating')
  double? personalRating;

  @JsonKey(name: 'personalNotes')
  String? personalNotes;

  @JsonKey(name: 'dateAdded')
  DateTime? dateAdded;

  ItemResponse(
    this.id,
    this.title,
    this.category,
    this.posterUrl,
    this.releaseDate, {
    this.personalRating,
    this.personalNotes,
    this.dateAdded,
  });

  // from json
  factory ItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$ItemResponseToJson(this);
}

@JsonSerializable()
class MainDataResponse {
  @JsonKey(name: 'todos')
  List<ItemResponse>? todos;

  @JsonKey(name: 'finished')
  List<ItemResponse>? finished;

  MainDataResponse(this.todos, this.finished);

  // from json
  factory MainDataResponse.fromJson(Map<String, dynamic> json) =>
      _$MainDataResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$MainDataResponseToJson(this);
}

@JsonSerializable()
class MainResponse extends BaseResponse {
  @JsonKey(name: 'data')
  MainDataResponse? data;

  MainResponse(this.data);

  // from json
  factory MainResponse.fromJson(Map<String, dynamic> json) =>
      _$MainResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$MainResponseToJson(this);
}

// books API Responses
@JsonSerializable()
class BooksSearchResponse {
  @JsonKey(name: 'items')
  List<BookSearchItem>? results;

  BooksSearchResponse({this.results});

  factory BooksSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$BooksSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BooksSearchResponseToJson(this);
}

@JsonSerializable()
class BookSearchItem {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'volumeInfo')
  BookVolumeInfo? volumeInfo;

  String? get title => volumeInfo?.title;
  String? get releaseDate => volumeInfo?.publishedDate;
  String? get posterUrl =>
      volumeInfo?.imageLinks?.thumbnail ??
      volumeInfo?.imageLinks?.smallThumbnail;

  BookSearchItem({this.id, this.volumeInfo});

  factory BookSearchItem.fromJson(Map<String, dynamic> json) =>
      _$BookSearchItemFromJson(json);
  Map<String, dynamic> toJson() => _$BookSearchItemToJson(this);
}

@JsonSerializable()
class BookDetailsResponse {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'volumeInfo')
  BookVolumeInfo? volumeInfo;

  String? get title => volumeInfo?.title;
  String? get description => volumeInfo?.description;
  String? get releaseDate => volumeInfo?.publishedDate;
  double? get rating => volumeInfo?.averageRating;
  String? get publisher => volumeInfo?.publisher;
  List<String>? get genres => volumeInfo?.categories;
  List<String> get imageGalleryUrls => [
    volumeInfo?.imageLinks?.large,
    volumeInfo?.imageLinks?.medium,
    volumeInfo?.imageLinks?.small,
    volumeInfo?.imageLinks?.thumbnail,
    volumeInfo?.imageLinks?.smallThumbnail,
  ].where((url) => url != null && url.isNotEmpty).cast<String>().toList();
  BookDetailsResponse({this.id, this.volumeInfo});

  factory BookDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$BookDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BookDetailsResponseToJson(this);
}

@JsonSerializable()
class BookVolumeInfo {
  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'authors')
  List<String>? authors;

  @JsonKey(name: 'publishedDate')
  String? publishedDate;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'averageRating')
  double? averageRating;

  @JsonKey(name: 'publisher')
  String? publisher;

  @JsonKey(name: 'imageLinks')
  BookImageLinks? imageLinks;

  @JsonKey(name: 'categories')
  List<String>? categories;

  BookVolumeInfo({
    this.title,
    this.authors,
    this.publishedDate,
    this.description,
    this.averageRating,
    this.publisher,
    this.imageLinks,
    this.categories,
  });

  factory BookVolumeInfo.fromJson(Map<String, dynamic> json) =>
      _$BookVolumeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BookVolumeInfoToJson(this);
}

@JsonSerializable()
class BookImageLinks {
  @JsonKey(name: 'smallThumbnail')
  String? smallThumbnail;

  @JsonKey(name: 'thumbnail')
  String? thumbnail;

  @JsonKey(name: 'small')
  String? small;

  @JsonKey(name: 'medium')
  String? medium;

  @JsonKey(name: 'large')
  String? large;

  BookImageLinks({
    this.smallThumbnail,
    this.thumbnail,
    this.small,
    this.medium,
    this.large,
  });

  factory BookImageLinks.fromJson(Map<String, dynamic> json) =>
      _$BookImageLinksFromJson(json);
  Map<String, dynamic> toJson() => _$BookImageLinksToJson(this);
}

// games API Responses
@JsonSerializable()
class GamesSearchResponse {
  @JsonKey(name: 'results')
  List<GameSearchItem>? results;

  GamesSearchResponse({this.results});

  factory GamesSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$GamesSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GamesSearchResponseToJson(this);
}

@JsonSerializable()
class GameSearchItem {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? title;

  @JsonKey(name: 'released')
  String? releaseDate;

  @JsonKey(name: 'background_image')
  String? posterUrl;

  GameSearchItem({this.id, this.title, this.releaseDate, this.posterUrl});

  factory GameSearchItem.fromJson(Map<String, dynamic> json) =>
      _$GameSearchItemFromJson(json);
  Map<String, dynamic> toJson() => _$GameSearchItemToJson(this);
}

@JsonSerializable()
class GameDetailsResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? title;

  @JsonKey(name: 'description_raw')
  String? description;

  @JsonKey(name: 'released')
  String? releaseDate;

  @JsonKey(name: 'rating')
  double? rating;

  @JsonKey(name: 'publishers')
  List<GamePublisherInfo>? publishers;

  @JsonKey(name: 'platforms')
  List<GamePlatformInfoWrapper>? platformWrappers;

  @JsonKey(name: 'background_image')
  String? mainImageUrl;

  @JsonKey(name: 'background_image_additional')
  String? additionalImageUrl;

  @JsonKey(name: 'genres')
  List<GameGenreInfo>? genresInfo;

  List<String> get genres =>
      genresInfo
          ?.map((g) => g.name)
          .where((name) => name != null)
          .cast<String>()
          .toList() ??
      [];

  List<String> get imageGalleryUrls {
    final List<String> images = [];
    if (mainImageUrl != null && mainImageUrl!.isNotEmpty) {
      images.add(mainImageUrl!);
    }
    if (additionalImageUrl != null && additionalImageUrl!.isNotEmpty) {
      images.add(additionalImageUrl!);
    }
    return images;
  }

  List<String> get platformNames =>
      platformWrappers
          ?.map((p) => p.platform?.name)
          .where((name) => name != null)
          .cast<String>()
          .toList() ??
      [];

  String? get publisherName =>
      publishers?.isNotEmpty ?? false ? publishers!.first.name : null;

  GameDetailsResponse({
    this.id,
    this.title,
    this.description,
    this.releaseDate,
    this.rating,
    this.publishers,
    this.platformWrappers,
    this.mainImageUrl,
    this.additionalImageUrl,
    this.genresInfo,
  });

  factory GameDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$GameDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GameDetailsResponseToJson(this);
}

@JsonSerializable()
class GameGenreInfo {
  @JsonKey(name: 'name')
  String? name;

  GameGenreInfo({this.name});
  factory GameGenreInfo.fromJson(Map<String, dynamic> json) =>
      _$GameGenreInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GameGenreInfoToJson(this);
}

@JsonSerializable()
class GamePublisherInfo {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? name;

  GamePublisherInfo({this.id, this.name});
  factory GamePublisherInfo.fromJson(Map<String, dynamic> json) =>
      _$GamePublisherInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GamePublisherInfoToJson(this);
}

@JsonSerializable()
class GamePlatformInfoWrapper {
  @JsonKey(name: 'platform')
  GamePlatformInfo? platform;

  GamePlatformInfoWrapper({this.platform});
  factory GamePlatformInfoWrapper.fromJson(Map<String, dynamic> json) =>
      _$GamePlatformInfoWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$GamePlatformInfoWrapperToJson(this);
}

@JsonSerializable()
class GamePlatformInfo {
  @JsonKey(name: 'name')
  String? name;

  GamePlatformInfo({this.name});
  factory GamePlatformInfo.fromJson(Map<String, dynamic> json) =>
      _$GamePlatformInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GamePlatformInfoToJson(this);
}

// movies & TV Series API Responses
@JsonSerializable()
class MoviesSearchResponse {
  @JsonKey(name: 'results')
  List<MovieSearchItem>? results;

  MoviesSearchResponse({this.results});
  factory MoviesSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MoviesSearchResponseToJson(this);
}

@JsonSerializable()
class MovieSearchItem {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'release_date')
  String? releaseDate;

  @JsonKey(name: 'poster_path')
  String? posterPath;

  String? get posterUrl => posterPath != null
      ? '${Constants.tmdbImageBaseUrl}w500$posterPath'
      : null;

  MovieSearchItem({this.id, this.title, this.releaseDate, this.posterPath});
  factory MovieSearchItem.fromJson(Map<String, dynamic> json) =>
      _$MovieSearchItemFromJson(json);
  Map<String, dynamic> toJson() => _$MovieSearchItemToJson(this);
}

@JsonSerializable()
class TvSearchResponse {
  @JsonKey(name: 'results')
  List<TvSearchItem>? results;

  TvSearchResponse({this.results});
  factory TvSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$TvSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TvSearchResponseToJson(this);
}

@JsonSerializable()
class TvSearchItem {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? title;

  @JsonKey(name: 'first_air_date')
  String? releaseDate;

  @JsonKey(name: 'poster_path')
  String? posterPath;

  String? get posterUrl => posterPath != null
      ? '${Constants.tmdbImageBaseUrl}w500$posterPath'
      : null;

  TvSearchItem({this.id, this.title, this.releaseDate, this.posterPath});
  factory TvSearchItem.fromJson(Map<String, dynamic> json) =>
      _$TvSearchItemFromJson(json);
  Map<String, dynamic> toJson() => _$TvSearchItemToJson(this);
}

@JsonSerializable()
class MovieDetailsResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'overview')
  String? description;

  @JsonKey(name: 'release_date')
  String? releaseDate;

  @JsonKey(name: 'vote_average')
  double? rating;

  @JsonKey(name: 'production_companies')
  List<TmdbCompanyInfo>? productionCompanies;

  @JsonKey(name: 'images')
  TmdbImagesResponse? images;

  @JsonKey(name: 'genres')
  List<TmdbGenreInfo>? genresInfo;

  String? get companyName => productionCompanies?.isNotEmpty ?? false
      ? productionCompanies!.first.name
      : null;

  List<String> get genres =>
      genresInfo
          ?.map((g) => g.name)
          .where((name) => name != null)
          .cast<String>()
          .toList() ??
      [];

  List<String> get imageGalleryUrls {
    final List<String?> paths = [];
    paths.addAll(images?.backdrops?.map((img) => img.filePath) ?? []);
    paths.addAll(images?.posters?.map((img) => img.filePath) ?? []);
    return paths
        .where((path) => path != null && path.isNotEmpty)
        .map((path) => '${Constants.tmdbImageBaseUrl}w780$path')
        .toList()
        .cast<String>();
  }

  MovieDetailsResponse({
    this.id,
    this.title,
    this.description,
    this.releaseDate,
    this.rating,
    this.productionCompanies,
    this.images,
    this.genresInfo,
  });

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailsResponseToJson(this);
}

@JsonSerializable()
class TvDetailsResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? title;

  @JsonKey(name: 'overview')
  String? description;

  @JsonKey(name: 'first_air_date')
  String? releaseDate;

  @JsonKey(name: 'vote_average')
  double? rating;

  @JsonKey(name: 'networks')
  List<TmdbCompanyInfo>? networks;

  @JsonKey(name: 'production_companies')
  List<TmdbCompanyInfo>? productionCompanies;

  @JsonKey(name: 'images')
  TmdbImagesResponse? images;

  @JsonKey(name: 'genres')
  List<TmdbGenreInfo>? genresInfo;

  // Helper getters
  String? get companyName => (networks?.isNotEmpty ?? false)
      ? networks!.first.name
      : (productionCompanies?.isNotEmpty ?? false
            ? productionCompanies!.first.name
            : null);

  List<String> get genres =>
      genresInfo
          ?.map((g) => g.name)
          .where((name) => name != null)
          .cast<String>()
          .toList() ??
      [];

  List<String> get imageGalleryUrls {
    final List<String?> paths = [];
    paths.addAll(images?.backdrops?.map((img) => img.filePath) ?? []);
    paths.addAll(images?.posters?.map((img) => img.filePath) ?? []);
    return paths
        .where((path) => path != null && path.isNotEmpty)
        .map((path) => '${Constants.tmdbImageBaseUrl}w780$path')
        .toList()
        .cast<String>();
  }

  TvDetailsResponse({
    this.id,
    this.title,
    this.description,
    this.releaseDate,
    this.rating,
    this.networks,
    this.productionCompanies,
    this.images,
    this.genresInfo,
  });

  factory TvDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$TvDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TvDetailsResponseToJson(this);
}

@JsonSerializable()
class TmdbGenreInfo {
  @JsonKey(name: 'name')
  String? name;

  TmdbGenreInfo({this.name});
  factory TmdbGenreInfo.fromJson(Map<String, dynamic> json) =>
      _$TmdbGenreInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbGenreInfoToJson(this);
}

@JsonSerializable()
class TmdbCompanyInfo {
  @JsonKey(name: 'name')
  String? name;

  TmdbCompanyInfo({this.name});
  factory TmdbCompanyInfo.fromJson(Map<String, dynamic> json) =>
      _$TmdbCompanyInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbCompanyInfoToJson(this);
}

@JsonSerializable()
class TmdbImagesResponse {
  @JsonKey(name: 'backdrops')
  List<TmdbImageInfo>? backdrops;

  @JsonKey(name: 'posters')
  List<TmdbImageInfo>? posters;

  TmdbImagesResponse({this.backdrops, this.posters});
  factory TmdbImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$TmdbImagesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbImagesResponseToJson(this);
}

@JsonSerializable()
class TmdbImageInfo {
  @JsonKey(name: 'file_path')
  String? filePath;

  TmdbImageInfo({this.filePath});
  factory TmdbImageInfo.fromJson(Map<String, dynamic> json) =>
      _$TmdbImageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbImageInfoToJson(this);
}
