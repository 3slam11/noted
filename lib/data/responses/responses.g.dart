// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemResponse _$ItemResponseFromJson(Map<String, dynamic> json) => ItemResponse(
  json['id'] as String?,
  json['title'] as String?,
  $enumDecodeNullable(_$CategoryEnumMap, json['category']),
  json['posterUrl'] as String?,
  json['releaseDate'] as String?,
  personalRating: (json['personalRating'] as num?)?.toDouble(),
  personalNotes: json['personalNotes'] as String?,
);

Map<String, dynamic> _$ItemResponseToJson(ItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _$CategoryEnumMap[instance.category],
      'posterUrl': instance.posterUrl,
      'releaseDate': instance.releaseDate,
      'personalRating': instance.personalRating,
      'personalNotes': instance.personalNotes,
    };

const _$CategoryEnumMap = {
  Category.all: 'all',
  Category.movies: 'movies',
  Category.series: 'series',
  Category.books: 'books',
  Category.games: 'games',
};

MainDataResponse _$MainDataResponseFromJson(Map<String, dynamic> json) =>
    MainDataResponse(
      (json['todos'] as List<dynamic>?)
          ?.map((e) => ItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['finished'] as List<dynamic>?)
          ?.map((e) => ItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MainDataResponseToJson(MainDataResponse instance) =>
    <String, dynamic>{'todos': instance.todos, 'finished': instance.finished};

MainResponse _$MainResponseFromJson(Map<String, dynamic> json) =>
    MainResponse(
        json['data'] == null
            ? null
            : MainDataResponse.fromJson(json['data'] as Map<String, dynamic>),
      )
      ..status = (json['status'] as num?)?.toInt()
      ..message = json['message'] as String?;

Map<String, dynamic> _$MainResponseToJson(MainResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

BooksSearchResponse _$BooksSearchResponseFromJson(Map<String, dynamic> json) =>
    BooksSearchResponse(
      results: (json['items'] as List<dynamic>?)
          ?.map((e) => BookSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BooksSearchResponseToJson(
  BooksSearchResponse instance,
) => <String, dynamic>{'items': instance.results};

BookSearchItem _$BookSearchItemFromJson(Map<String, dynamic> json) =>
    BookSearchItem(
      id: json['id'] as String?,
      volumeInfo: json['volumeInfo'] == null
          ? null
          : BookVolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookSearchItemToJson(BookSearchItem instance) =>
    <String, dynamic>{'id': instance.id, 'volumeInfo': instance.volumeInfo};

BookDetailsResponse _$BookDetailsResponseFromJson(Map<String, dynamic> json) =>
    BookDetailsResponse(
      id: json['id'] as String?,
      volumeInfo: json['volumeInfo'] == null
          ? null
          : BookVolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookDetailsResponseToJson(
  BookDetailsResponse instance,
) => <String, dynamic>{'id': instance.id, 'volumeInfo': instance.volumeInfo};

BookVolumeInfo _$BookVolumeInfoFromJson(Map<String, dynamic> json) =>
    BookVolumeInfo(
      title: json['title'] as String?,
      publishedDate: json['publishedDate'] as String?,
      description: json['description'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      publisher: json['publisher'] as String?,
      imageLinks: json['imageLinks'] == null
          ? null
          : BookImageLinks.fromJson(json['imageLinks'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookVolumeInfoToJson(BookVolumeInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'publishedDate': instance.publishedDate,
      'description': instance.description,
      'averageRating': instance.averageRating,
      'publisher': instance.publisher,
      'imageLinks': instance.imageLinks,
    };

BookImageLinks _$BookImageLinksFromJson(Map<String, dynamic> json) =>
    BookImageLinks(
      smallThumbnail: json['smallThumbnail'] as String?,
      thumbnail: json['thumbnail'] as String?,
      small: json['small'] as String?,
      medium: json['medium'] as String?,
      large: json['large'] as String?,
    );

Map<String, dynamic> _$BookImageLinksToJson(BookImageLinks instance) =>
    <String, dynamic>{
      'smallThumbnail': instance.smallThumbnail,
      'thumbnail': instance.thumbnail,
      'small': instance.small,
      'medium': instance.medium,
      'large': instance.large,
    };

GamesSearchResponse _$GamesSearchResponseFromJson(Map<String, dynamic> json) =>
    GamesSearchResponse(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => GameSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GamesSearchResponseToJson(
  GamesSearchResponse instance,
) => <String, dynamic>{'results': instance.results};

GameSearchItem _$GameSearchItemFromJson(Map<String, dynamic> json) =>
    GameSearchItem(
      id: (json['id'] as num?)?.toInt(),
      title: json['name'] as String?,
      releaseDate: json['released'] as String?,
      posterUrl: json['background_image'] as String?,
    );

Map<String, dynamic> _$GameSearchItemToJson(GameSearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'released': instance.releaseDate,
      'background_image': instance.posterUrl,
    };

GameDetailsResponse _$GameDetailsResponseFromJson(Map<String, dynamic> json) =>
    GameDetailsResponse(
      id: (json['id'] as num?)?.toInt(),
      title: json['name'] as String?,
      description: json['description_raw'] as String?,
      releaseDate: json['released'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      publishers: (json['publishers'] as List<dynamic>?)
          ?.map((e) => GamePublisherInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      platformWrappers: (json['platforms'] as List<dynamic>?)
          ?.map(
            (e) => GamePlatformInfoWrapper.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      mainImageUrl: json['background_image'] as String?,
      additionalImageUrl: json['background_image_additional'] as String?,
    );

Map<String, dynamic> _$GameDetailsResponseToJson(
  GameDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.title,
  'description_raw': instance.description,
  'released': instance.releaseDate,
  'rating': instance.rating,
  'publishers': instance.publishers,
  'platforms': instance.platformWrappers,
  'background_image': instance.mainImageUrl,
  'background_image_additional': instance.additionalImageUrl,
};

GamePublisherInfo _$GamePublisherInfoFromJson(Map<String, dynamic> json) =>
    GamePublisherInfo(name: json['name'] as String?);

Map<String, dynamic> _$GamePublisherInfoToJson(GamePublisherInfo instance) =>
    <String, dynamic>{'name': instance.name};

GamePlatformInfoWrapper _$GamePlatformInfoWrapperFromJson(
  Map<String, dynamic> json,
) => GamePlatformInfoWrapper(
  platform: json['platform'] == null
      ? null
      : GamePlatformInfo.fromJson(json['platform'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GamePlatformInfoWrapperToJson(
  GamePlatformInfoWrapper instance,
) => <String, dynamic>{'platform': instance.platform};

GamePlatformInfo _$GamePlatformInfoFromJson(Map<String, dynamic> json) =>
    GamePlatformInfo(name: json['name'] as String?);

Map<String, dynamic> _$GamePlatformInfoToJson(GamePlatformInfo instance) =>
    <String, dynamic>{'name': instance.name};

MoviesSearchResponse _$MoviesSearchResponseFromJson(
  Map<String, dynamic> json,
) => MoviesSearchResponse(
  results: (json['results'] as List<dynamic>?)
      ?.map((e) => MovieSearchItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MoviesSearchResponseToJson(
  MoviesSearchResponse instance,
) => <String, dynamic>{'results': instance.results};

MovieSearchItem _$MovieSearchItemFromJson(Map<String, dynamic> json) =>
    MovieSearchItem(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      releaseDate: json['release_date'] as String?,
      posterPath: json['poster_path'] as String?,
    );

Map<String, dynamic> _$MovieSearchItemToJson(MovieSearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'release_date': instance.releaseDate,
      'poster_path': instance.posterPath,
    };

TvSearchResponse _$TvSearchResponseFromJson(Map<String, dynamic> json) =>
    TvSearchResponse(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => TvSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TvSearchResponseToJson(TvSearchResponse instance) =>
    <String, dynamic>{'results': instance.results};

TvSearchItem _$TvSearchItemFromJson(Map<String, dynamic> json) => TvSearchItem(
  id: (json['id'] as num?)?.toInt(),
  title: json['name'] as String?,
  releaseDate: json['first_air_date'] as String?,
  posterPath: json['poster_path'] as String?,
);

Map<String, dynamic> _$TvSearchItemToJson(TvSearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'first_air_date': instance.releaseDate,
      'poster_path': instance.posterPath,
    };

MovieDetailsResponse _$MovieDetailsResponseFromJson(
  Map<String, dynamic> json,
) => MovieDetailsResponse(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['overview'] as String?,
  releaseDate: json['release_date'] as String?,
  rating: (json['vote_average'] as num?)?.toDouble(),
  productionCompanies: (json['production_companies'] as List<dynamic>?)
      ?.map((e) => TmdbCompanyInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  images: json['images'] == null
      ? null
      : TmdbImagesResponse.fromJson(json['images'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovieDetailsResponseToJson(
  MovieDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'overview': instance.description,
  'release_date': instance.releaseDate,
  'vote_average': instance.rating,
  'production_companies': instance.productionCompanies,
  'images': instance.images,
};

TvDetailsResponse _$TvDetailsResponseFromJson(Map<String, dynamic> json) =>
    TvDetailsResponse(
      id: (json['id'] as num?)?.toInt(),
      title: json['name'] as String?,
      description: json['overview'] as String?,
      releaseDate: json['first_air_date'] as String?,
      rating: (json['vote_average'] as num?)?.toDouble(),
      networks: (json['networks'] as List<dynamic>?)
          ?.map((e) => TmdbCompanyInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionCompanies: (json['production_companies'] as List<dynamic>?)
          ?.map((e) => TmdbCompanyInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: json['images'] == null
          ? null
          : TmdbImagesResponse.fromJson(json['images'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TvDetailsResponseToJson(TvDetailsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'overview': instance.description,
      'first_air_date': instance.releaseDate,
      'vote_average': instance.rating,
      'networks': instance.networks,
      'production_companies': instance.productionCompanies,
      'images': instance.images,
    };

TmdbCompanyInfo _$TmdbCompanyInfoFromJson(Map<String, dynamic> json) =>
    TmdbCompanyInfo(name: json['name'] as String?);

Map<String, dynamic> _$TmdbCompanyInfoToJson(TmdbCompanyInfo instance) =>
    <String, dynamic>{'name': instance.name};

TmdbImagesResponse _$TmdbImagesResponseFromJson(Map<String, dynamic> json) =>
    TmdbImagesResponse(
      backdrops: (json['backdrops'] as List<dynamic>?)
          ?.map((e) => TmdbImageInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      posters: (json['posters'] as List<dynamic>?)
          ?.map((e) => TmdbImageInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TmdbImagesResponseToJson(TmdbImagesResponse instance) =>
    <String, dynamic>{
      'backdrops': instance.backdrops,
      'posters': instance.posters,
    };

TmdbImageInfo _$TmdbImageInfoFromJson(Map<String, dynamic> json) =>
    TmdbImageInfo(filePath: json['file_path'] as String?);

Map<String, dynamic> _$TmdbImageInfoToJson(TmdbImageInfo instance) =>
    <String, dynamic>{'file_path': instance.filePath};
