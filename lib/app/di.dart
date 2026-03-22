import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/data/data_source/local_data_source.dart';
import 'package:noted/data/data_source/remote_data_source.dart';
import 'package:noted/data/network/app_api.dart';
import 'package:noted/data/network/dio_factory.dart';
import 'package:noted/data/network/network_info.dart';
import 'package:noted/data/objectbox/objectbox_manager.dart';
import 'package:noted/data/repository/repository_impl.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/domain/usecases/details_usecase.dart';
import 'package:noted/domain/usecases/history_usecase.dart';
import 'package:noted/domain/usecases/main_usecase.dart';
import 'package:noted/domain/usecases/recommendations_usecase.dart';
import 'package:noted/domain/usecases/search_usecase.dart';
import 'package:noted/domain/usecases/saved_usecase.dart';
import 'package:noted/presentation/backupAndRestore/backup_and_restore_viewmodel.dart';
import 'package:noted/presentation/changeApi/change_api_viewmodel.dart';
import 'package:noted/presentation/details/details_viewmodel.dart';
import 'package:noted/presentation/history/history_view_model.dart';
import 'package:noted/presentation/main/main_view_model.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:noted/presentation/search/search_viewmodel.dart';
import 'package:noted/presentation/settings/settings_viewmodel.dart';
import 'package:noted/presentation/statistics/statistics_viewmodel.dart';
import 'package:noted/presentation/saved/saved_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;
// module to store all generic dependency injections
Future<void> initAppModule() async {
  await ObjectBoxManager.initialize();

  instance.registerLazySingleton<ObjectBoxManager>(
    () => ObjectBoxManager.instance,
  );

  instance.registerLazySingleton<DataGlobalNotifier>(
    () => DataGlobalNotifier(),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // app preferences
  instance.registerLazySingleton<AppPrefs>(() => AppPrefs(instance()));
  // network info
  instance.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnection()),
  );
  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));
  // app service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  instance.registerLazySingleton<BooksApiClient>(() => BooksApiClient(dio));
  instance.registerLazySingleton<GamesApiClient>(() => GamesApiClient(dio));
  instance.registerLazySingleton<TmdbApiClient>(() => TmdbApiClient(dio));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(instance()),
  ); // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(instance(), instance(), instance(), instance()),
  );
  // repository
  instance.registerLazySingleton<Repository>(
    () => RepositoryImpl(instance(), instance(), instance()),
  );

  // theme manager
  instance.registerLazySingleton<ThemeManager>(() => ThemeManager(instance()));
}

void initHomeModule() {
  initMainModule();
  initSearchModule();
  initHistoryModule();
  initSavedModule();
  initSettingsModule();
}

void initMainModule() {
  if (!GetIt.I.isRegistered<MainUsecase>()) {
    instance.registerFactory<MainUsecase>(() => MainUsecase(instance()));
    instance.registerFactory<MainViewModel>(
      () => MainViewModel(instance(), instance(), instance()),
    );
  }
}

void initSearchModule() {
  if (!GetIt.I.isRegistered<SearchUsecase>()) {
    instance.registerFactory<SearchUsecase>(() => SearchUsecase(instance()));
    instance.registerFactory<SearchViewModel>(
      () => SearchViewModel(instance(), instance()),
    );
  }
}

void initDetailsModule() {
  if (!GetIt.I.isRegistered<DetailsUsecase>()) {
    instance.registerFactory<DetailsUsecase>(() => DetailsUsecase(instance()));
    instance.registerFactory<RecommendationsUsecase>(
      () => RecommendationsUsecase(instance()),
    );
    instance.registerFactory<DetailsViewModel>(
      () => DetailsViewModel(instance(), instance()),
    );
  }
}

void initSettingsModule() {
  if (!GetIt.I.isRegistered<SettingsViewModel>()) {
    instance.registerFactory<SettingsViewModel>(
      () => SettingsViewModel(instance(), instance(), instance()),
    );
  }
}

void initHistoryModule() {
  if (!GetIt.I.isRegistered<HistoryViewModel>()) {
    instance.registerFactory<HistoryUsecase>(() => HistoryUsecase(instance()));
    instance.registerFactory<HistoryViewModel>(
      () => HistoryViewModel(instance(), instance(), instance()),
    );
  }
}

void initSavedModule() {
  if (!GetIt.I.isRegistered<SavedViewModel>()) {
    instance.registerFactory<SavedUsecase>(() => SavedUsecase(instance()));
    instance.registerFactory<SavedViewModel>(
      () => SavedViewModel(instance(), instance(), instance()),
    );
  }
}

void initStatisticsModule() {
  if (!GetIt.I.isRegistered<StatisticsViewModel>()) {
    instance.registerFactory<StatisticsViewModel>(
      () => StatisticsViewModel(instance()),
    );
  }
}

void initChangeApiModule() {
  if (!GetIt.I.isRegistered<ChangeApiViewModel>()) {
    instance.registerFactory<ChangeApiViewModel>(
      () => ChangeApiViewModel(instance()),
    );
  }
}

void initBackupAndRestoreModule() {
  if (!GetIt.I.isRegistered<BackupAndRestoreViewModel>()) {
    instance.registerFactory<BackupAndRestoreViewModel>(
      () => BackupAndRestoreViewModel(
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
      ),
    );
  }
}
