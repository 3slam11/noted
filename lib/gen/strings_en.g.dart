///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Noted'
	String get appName => 'Noted';

	List<String> get months => [
		'January',
		'February',
		'March',
		'April',
		'May',
		'June',
		'July',
		'August',
		'September',
		'October',
		'November',
		'December',
	];
	late final TranslationsRoutesEn routes = TranslationsRoutesEn._(_root);
	late final TranslationsErrorHandlerEn errorHandler = TranslationsErrorHandlerEn._(_root);
	late final TranslationsStateRendererEn stateRenderer = TranslationsStateRendererEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsSortEn sort = TranslationsSortEn._(_root);
	late final TranslationsSearchEn search = TranslationsSearchEn._(_root);
	late final TranslationsDetailsEn details = TranslationsDetailsEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsLanguageSettingsEn languageSettings = TranslationsLanguageSettingsEn._(_root);
	late final TranslationsThemeSettingsEn themeSettings = TranslationsThemeSettingsEn._(_root);
	late final TranslationsFontSettingsEn fontSettings = TranslationsFontSettingsEn._(_root);
	late final TranslationsBackupAndRestoreEn backupAndRestore = TranslationsBackupAndRestoreEn._(_root);
	late final TranslationsHistoryEn history = TranslationsHistoryEn._(_root);
	late final TranslationsApiSettingsEn apiSettings = TranslationsApiSettingsEn._(_root);
	late final TranslationsStatisticsEn statistics = TranslationsStatisticsEn._(_root);
	late final TranslationsAboutEn about = TranslationsAboutEn._(_root);
}

// Path: routes
class TranslationsRoutesEn {
	TranslationsRoutesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Route Found'
	String get noRouteFound => 'No Route Found';
}

// Path: errorHandler
class TranslationsErrorHandlerEn {
	TranslationsErrorHandlerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Something went wrong, try again later'
	String get defaultError => 'Something went wrong, try again later';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'No Content'
	String get noContent => 'No Content';

	/// en: 'Bad Request'
	String get badRequest => 'Bad Request';

	/// en: 'Unauthorized'
	String get unauthorized => 'Unauthorized';

	/// en: 'Forbidden'
	String get forbidden => 'Forbidden';

	/// en: 'Internal Server Error'
	String get internalServerError => 'Internal Server Error';

	/// en: 'Not Found'
	String get notFound => 'Not Found';

	/// en: 'Time Out'
	String get timeOut => 'Time Out';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Cache Error'
	String get cacheError => 'Cache Error';

	/// en: 'No Internet Connection'
	String get noInternetConnection => 'No Internet Connection';

	/// en: 'An error occurred'
	String get errorOccurred => 'An error occurred';

	/// en: 'Connection Issues'
	String get connectionIssuesTitle => 'Connection Issues';

	/// en: 'There might be several reasons for this issue:'
	String get connectionIssuesSubtitle => 'There might be several reasons for this issue:';

	/// en: 'Internet might be not working.'
	String get internetNotWorking => 'Internet might be not working.';

	/// en: 'Default API might have hit the capacity.'
	String get apiCapacityHit => 'Default API might have hit the capacity.';

	/// en: 'Your custom API might be written incorrectly.'
	String get customApiError => 'Your custom API might be written incorrectly.';

	/// en: 'Site might be down at the moment, wait a few minutes and try later.'
	String get siteDownError => 'Site might be down at the moment, wait a few minutes and try later.';
}

// Path: stateRenderer
class TranslationsStateRendererEn {
	TranslationsStateRendererEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Content'
	String get content => 'Content';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Loading'
	String get loading => 'Loading';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Ok'
	String get ok => 'Ok';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Entertainment list for '
	String get titleSection => 'Entertainment list for ';

	/// en: 'This list is empty'
	String get emptySection => 'This list is empty';

	/// en: 'Finished List'
	String get finishedList => 'Finished List';

	/// en: 'Saved for Later'
	String get savedList => 'Saved for Later';

	/// en: 'Movies'
	String get movies => 'Movies';

	/// en: 'Series'
	String get series => 'Series';

	/// en: 'Games'
	String get games => 'Games';

	/// en: 'Books'
	String get books => 'Books';

	/// en: 'Anime'
	String get anime => 'Anime';

	/// en: 'Manga'
	String get manga => 'Manga';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Deleted'
	String get deleted => 'Deleted';

	/// en: 'Undo'
	String get undo => 'Undo';

	/// en: 'New Month Started! 🎉'
	String get newMonthStarted => 'New Month Started! 🎉';

	/// en: 'Welcome to ${month}!'
	String description({required Object month}) => 'Welcome to ${month}!';

	/// en: 'Your finished items have been moved to history. Here are your unfinished items from last month:'
	String get description2 => 'Your finished items have been moved to history. Here are your unfinished items from last month:';

	/// en: '📝 Pending: '
	String get pending => '📝 Pending: ';

	/// en: '🎯 Completed: '
	String get completed => '🎯 Completed: ';

	/// en: 'Select All'
	String get selectAll => 'Select All';

	/// en: 'Deselect All'
	String get deselectAll => 'Deselect All';

	/// en: 'Delete All'
	String get deleteAll => 'Delete All';

	/// en: 'Add All'
	String get addAll => 'Add All';

	/// en: 'Keep Selected'
	String get keepSelected => 'Keep Selected';

	/// en: 'No completed items yet'
	String get noCompleted => 'No completed items yet';

	/// en: 'No saved items yet'
	String get noSaved => 'No saved items yet';

	/// en: 'Congratulations!'
	String get congratulations => 'Congratulations!';

	/// en: 'You have completed everything last month!'
	String get todosDone => 'You have completed everything last month!';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Either you're a time traveler or you messed with your date settings! 🕰️'
	String get timeWrong => 'Either you\'re a time traveler or you messed with your date settings! 🕰️';

	/// en: 'The app detected that your current date may be wrong. This could mess with your lists.'
	String get timeWrongDescription => 'The app detected that your current date may be wrong. This could mess with your lists.';

	/// en: 'Continue'
	String get continueAnyway => 'Continue';

	/// en: 'Item Actions'
	String get itemActions => 'Item Actions';

	/// en: 'Move to todo'
	String get moveToTodo => 'Move to todo';

	/// en: 'Move to finished'
	String get moveToFinished => 'Move to finished';

	/// en: 'Move to history'
	String get moveToHistory => 'Move to history';

	/// en: 'Move to saved'
	String get moveToSaved => 'Move to saved';

	/// en: 'Add to To-Do'
	String get addToTodo => 'Add to To-Do';

	/// en: 'Add to Saved'
	String get addToSaved => 'Add to Saved';

	/// en: 'Edit/View Notes'
	String get editNotes => 'Edit/View Notes';

	/// en: 'Your Rating'
	String get yourRating => 'Your Rating';

	/// en: 'Your Notes'
	String get yourNotes => 'Your Notes';

	/// en: 'Add your thoughts here...'
	String get notesHint => 'Add your thoughts here...';

	/// en: 'No note yet.'
	String get noNotes => 'No note yet.';

	/// en: 'Note saved.'
	String get notesSaved => 'Note saved.';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';
}

// Path: sort
class TranslationsSortEn {
	TranslationsSortEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sort'
	String get sort => 'Sort';

	/// en: 'Sort by'
	String get sortBy => 'Sort by';

	/// en: 'Title (A-Z)'
	String get titleAsc => 'Title (A-Z)';

	/// en: 'Title (Z-A)'
	String get titleDesc => 'Title (Z-A)';

	/// en: 'Release Date (Newest)'
	String get releaseDateNewest => 'Release Date (Newest)';

	/// en: 'Release Date (Oldest)'
	String get releaseDateOldest => 'Release Date (Oldest)';

	/// en: 'Rating (Highest)'
	String get ratingHighest => 'Rating (Highest)';

	/// en: 'Rating (Lowest)'
	String get ratingLowest => 'Rating (Lowest)';

	/// en: 'Date Added (Newest)'
	String get dateAddedNewest => 'Date Added (Newest)';

	/// en: 'Date Added (Oldest)'
	String get dateAddedOldest => 'Date Added (Oldest)';
}

// Path: search
class TranslationsSearchEn {
	TranslationsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Search...'
	String get searchPlaceholder => 'Search...';

	/// en: 'Search for anything'
	String get searchForSomething => 'Search for anything';

	/// en: 'No results found'
	String get noResultsFound => 'No results found';

	/// en: 'Can't search now'
	String get cantSearch => 'Can\'t search now';
}

// Path: details
class TranslationsDetailsEn {
	TranslationsDetailsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Details'
	String get title => 'Details';

	/// en: 'Movies'
	String get movies => 'Movies';

	/// en: 'Series'
	String get series => 'Series';

	/// en: 'Games'
	String get games => 'Games';

	/// en: 'Books'
	String get books => 'Books';

	/// en: 'Anime'
	String get anime => 'Anime';

	/// en: 'Manga'
	String get manga => 'Manga';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Genre'
	String get genres => 'Genre';

	/// en: 'Progress Tracker'
	String get progressTracker => 'Progress Tracker';

	/// en: 'Season'
	String get season => 'Season';

	/// en: 'Episode'
	String get episode => 'Episode';

	/// en: 'Chapter'
	String get chapter => 'Chapter';

	/// en: 'Volume'
	String get volume => 'Volume';

	/// en: 'Release Date'
	String get releaseDate => 'Release Date';

	/// en: 'Platforms'
	String get platforms => 'Platforms';

	/// en: 'Rating'
	String get rating => 'Rating';

	/// en: 'Publisher'
	String get publisher => 'Publisher';

	/// en: 'Studio'
	String get studio => 'Studio';

	/// en: 'Network'
	String get network => 'Network';

	/// en: 'More like this'
	String get moreLikeThis => 'More like this';

	/// en: 'No Recommendations'
	String get noRecommendations => 'No Recommendations';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Backup & Restore'
	String get backupAndRestore => 'Backup & Restore';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Font'
	String get font => 'Font';

	/// en: 'App Default'
	String get appDefaultFont => 'App Default';

	/// en: 'System Default'
	String get systemFont => 'System Default';

	/// en: 'Custom Font'
	String get customFont => 'Custom Font';

	/// en: 'Custom Font Details'
	String get customFontDetails => 'Custom Font Details';

	/// en: 'History'
	String get history => 'History';

	/// en: 'Change API'
	String get apiChange => 'Change API';

	/// en: 'Statistics'
	String get statistics => 'Statistics';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Month Rollover Behavior'
	String get monthRolloverBehavior => 'Month Rollover Behavior';

	/// en: 'Choose what happens at the start of a new month.'
	String get monthRolloverBehaviorDescription => 'Choose what happens at the start of a new month.';

	/// en: 'Full Rollover (Default)'
	String get rolloverFull => 'Full Rollover (Default)';

	/// en: 'Move finished items to history and ask which to-do items to keep.'
	String get rolloverFullDescription => 'Move finished items to history and ask which to-do items to keep.';

	/// en: 'Partial Rollover'
	String get rolloverPartial => 'Partial Rollover';

	/// en: 'Only move finished items to history. Keep all to-do items.'
	String get rolloverPartialDescription => 'Only move finished items to history. Keep all to-do items.';

	/// en: 'Manual'
	String get rolloverManual => 'Manual';

	/// en: 'Do nothing. I will manage my lists myself.'
	String get rolloverManualDescription => 'Do nothing. I will manage my lists myself.';

	/// en: 'Show Series Tracker'
	String get showSeriesTracker => 'Show Series Tracker';

	/// en: 'Display current season and episode for TV series on the main lists.'
	String get showSeriesTrackerDescription => 'Display current season and episode for TV series on the main lists.';
}

// Path: languageSettings
class TranslationsLanguageSettingsEn {
	TranslationsLanguageSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select Language'
	String get selectLanguage => 'Select Language';

	/// en: 'English'
	String get en => 'English';

	/// en: 'العربية'
	String get ar => 'العربية';
}

// Path: themeSettings
class TranslationsThemeSettingsEn {
	TranslationsThemeSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme Settings'
	String get themeSettings => 'Theme Settings';

	/// en: 'Auto Theme'
	String get autoTheme => 'Auto Theme';

	/// en: 'Manual Theme'
	String get manualTheme => 'Manual Theme';

	/// en: 'Automatically changes theme based on current month'
	String get autoThemeDescription => 'Automatically changes theme based on current month';

	/// en: 'Select Theme:'
	String get selectTheme => 'Select Theme:';
}

// Path: fontSettings
class TranslationsFontSettingsEn {
	TranslationsFontSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Font Settings'
	String get title => 'Font Settings';

	/// en: 'Change'
	String get change => 'Change';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'No custom font selected'
	String get noCustomFont => 'No custom font selected';

	/// en: 'Select Font File (.ttf, .otf)''
	String get selectFontFile => 'Select Font File (.ttf, .otf)\'';
}

// Path: backupAndRestore
class TranslationsBackupAndRestoreEn {
	TranslationsBackupAndRestoreEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Backup & Restore'
	String get title => 'Backup & Restore';

	/// en: 'Backup Data'
	String get backupData => 'Backup Data';

	/// en: 'Restore Data'
	String get restoreData => 'Restore Data';

	/// en: 'Save your current lists to a local file.'
	String get backupDescription => 'Save your current lists to a local file.';

	/// en: 'Restore your lists from a previously saved backup file. This will overwrite current data.'
	String get restoreDescription => 'Restore your lists from a previously saved backup file. This will overwrite current data.';

	/// en: 'Backup successful!'
	String get backupSuccessful => 'Backup successful!';

	/// en: 'Backup failed: '
	String get backupFailed => 'Backup failed: ';

	/// en: 'Restore successful!'
	String get restoreSuccessful => 'Restore successful!';

	/// en: 'Restore failed: '
	String get restoreFailed => 'Restore failed: ';

	/// en: 'No file selected.'
	String get noFileSelected => 'No file selected.';

	/// en: 'Invalid backup file format or missing data.'
	String get invalidFileFormat => 'Invalid backup file format or missing data.';

	/// en: 'Select Backup File'
	String get selectBackupFile => 'Select Backup File';

	/// en: 'Save Backup File As'
	String get saveBackupFile => 'Save Backup File As';

	/// en: 'noted_backup.json'
	String get defaultBackupFileName => 'noted_backup.json';

	/// en: 'Yes'
	String get yes => 'Yes';

	/// en: 'No'
	String get no => 'No';

	/// en: 'Data restored successfully.'
	String get dataRestoredMessage => 'Data restored successfully.';
}

// Path: history
class TranslationsHistoryEn {
	TranslationsHistoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'History'
	String get history => 'History';

	/// en: 'Item'
	String get item => 'Item';

	/// en: 'Items'
	String get items => 'Items';

	/// en: 'No history yet'
	String get noHistory => 'No history yet';
}

// Path: apiSettings
class TranslationsApiSettingsEn {
	TranslationsApiSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Games API'
	String get gamesApiTitle => 'Games API';

	/// en: 'Get your API key from RAWG.io'
	String get gamesApiDescription => 'Get your API key from RAWG.io';

	/// en: 'Movies & TV Series API'
	String get moviesApiTitle => 'Movies & TV Series API';

	/// en: 'Get your API key from The Movie Database'
	String get moviesApiDescription => 'Get your API key from The Movie Database';

	/// en: 'Books API'
	String get booksApiTitle => 'Books API';

	/// en: 'Get your API key from Google Cloud Console'
	String get booksApiDescription => 'Get your API key from Google Cloud Console';

	/// en: 'Get API Key'
	String get getApiKey => 'Get API Key';

	/// en: 'API Key'
	String get apiKey => 'API Key';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';
}

// Path: statistics
class TranslationsStatisticsEn {
	TranslationsStatisticsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This Month'
	String get thisMonth => 'This Month';

	/// en: 'All Time'
	String get allTime => 'All Time';

	/// en: 'Total Items'
	String get totalItems => 'Total Items';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'No data yet'
	String get noData => 'No data yet';
}

// Path: about
class TranslationsAboutEn {
	TranslationsAboutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About This App'
	String get aboutThisApp => 'About This App';

	/// en: 'This app has been made for practice, so if you encounter any issue tell the developer on GitHub.'
	String get appDescription => 'This app has been made for practice, so if you encounter any issue tell the developer on GitHub.';

	/// en: 'Issue?'
	String get reportIssue => 'Issue?';

	/// en: 'View Project'
	String get viewProject => 'View Project';

	/// en: 'APIs Used'
	String get apisUsed => 'APIs Used';

	/// en: 'Games data comes from RAWG site'
	String get gamesDescription => 'Games data comes from RAWG site';

	/// en: 'Movies and TV Series'
	String get moviesAndTvSeries => 'Movies and TV Series';

	/// en: 'All data about movies and TV series comes from TMDB site'
	String get moviesAndTvSeriesDescription => 'All data about movies and TV series comes from TMDB site';

	/// en: 'All data about books comes from Google Books API'
	String get booksDescription => 'All data about books comes from Google Books API';

	/// en: 'Anime & Manga'
	String get animeAndManga => 'Anime & Manga';

	/// en: 'Anime and manga data comes from Jikan API, no API key needed'
	String get animeAndMangaDescription => 'Anime and manga data comes from Jikan API, no API key needed';

	/// en: 'Thanks to their free plan, the app became usable as it is now.'
	String get thanksMessage => 'Thanks to their free plan, the app became usable as it is now.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Noted',
			'months.0' => 'January',
			'months.1' => 'February',
			'months.2' => 'March',
			'months.3' => 'April',
			'months.4' => 'May',
			'months.5' => 'June',
			'months.6' => 'July',
			'months.7' => 'August',
			'months.8' => 'September',
			'months.9' => 'October',
			'months.10' => 'November',
			'months.11' => 'December',
			'routes.noRouteFound' => 'No Route Found',
			'errorHandler.defaultError' => 'Something went wrong, try again later',
			'errorHandler.success' => 'Success',
			'errorHandler.noContent' => 'No Content',
			'errorHandler.badRequest' => 'Bad Request',
			'errorHandler.unauthorized' => 'Unauthorized',
			'errorHandler.forbidden' => 'Forbidden',
			'errorHandler.internalServerError' => 'Internal Server Error',
			'errorHandler.notFound' => 'Not Found',
			'errorHandler.timeOut' => 'Time Out',
			'errorHandler.cancel' => 'Cancel',
			'errorHandler.cacheError' => 'Cache Error',
			'errorHandler.noInternetConnection' => 'No Internet Connection',
			'errorHandler.errorOccurred' => 'An error occurred',
			'errorHandler.connectionIssuesTitle' => 'Connection Issues',
			'errorHandler.connectionIssuesSubtitle' => 'There might be several reasons for this issue:',
			'errorHandler.internetNotWorking' => 'Internet might be not working.',
			'errorHandler.apiCapacityHit' => 'Default API might have hit the capacity.',
			'errorHandler.customApiError' => 'Your custom API might be written incorrectly.',
			'errorHandler.siteDownError' => 'Site might be down at the moment, wait a few minutes and try later.',
			'stateRenderer.content' => 'Content',
			'stateRenderer.error' => 'Error',
			'stateRenderer.loading' => 'Loading',
			'stateRenderer.retry' => 'Retry',
			'stateRenderer.ok' => 'Ok',
			'home.home' => 'Home',
			'home.titleSection' => 'Entertainment list for ',
			'home.emptySection' => 'This list is empty',
			'home.finishedList' => 'Finished List',
			'home.savedList' => 'Saved for Later',
			'home.movies' => 'Movies',
			'home.series' => 'Series',
			'home.games' => 'Games',
			'home.books' => 'Books',
			'home.anime' => 'Anime',
			'home.manga' => 'Manga',
			'home.all' => 'All',
			'home.deleted' => 'Deleted',
			'home.undo' => 'Undo',
			'home.newMonthStarted' => 'New Month Started! 🎉',
			'home.description' => ({required Object month}) => 'Welcome to ${month}!',
			'home.description2' => 'Your finished items have been moved to history. Here are your unfinished items from last month:',
			'home.pending' => '📝 Pending: ',
			'home.completed' => '🎯 Completed: ',
			'home.selectAll' => 'Select All',
			'home.deselectAll' => 'Deselect All',
			'home.deleteAll' => 'Delete All',
			'home.addAll' => 'Add All',
			'home.keepSelected' => 'Keep Selected',
			'home.noCompleted' => 'No completed items yet',
			'home.noSaved' => 'No saved items yet',
			'home.congratulations' => 'Congratulations!',
			'home.todosDone' => 'You have completed everything last month!',
			'home.close' => 'Close',
			'home.timeWrong' => 'Either you\'re a time traveler or you messed with your date settings! 🕰️',
			'home.timeWrongDescription' => 'The app detected that your current date may be wrong. This could mess with your lists.',
			'home.continueAnyway' => 'Continue',
			'home.itemActions' => 'Item Actions',
			'home.moveToTodo' => 'Move to todo',
			'home.moveToFinished' => 'Move to finished',
			'home.moveToHistory' => 'Move to history',
			'home.moveToSaved' => 'Move to saved',
			'home.addToTodo' => 'Add to To-Do',
			'home.addToSaved' => 'Add to Saved',
			'home.editNotes' => 'Edit/View Notes',
			'home.yourRating' => 'Your Rating',
			'home.yourNotes' => 'Your Notes',
			'home.notesHint' => 'Add your thoughts here...',
			'home.noNotes' => 'No note yet.',
			'home.notesSaved' => 'Note saved.',
			'home.save' => 'Save',
			'home.delete' => 'Delete',
			'sort.sort' => 'Sort',
			'sort.sortBy' => 'Sort by',
			'sort.titleAsc' => 'Title (A-Z)',
			'sort.titleDesc' => 'Title (Z-A)',
			'sort.releaseDateNewest' => 'Release Date (Newest)',
			'sort.releaseDateOldest' => 'Release Date (Oldest)',
			'sort.ratingHighest' => 'Rating (Highest)',
			'sort.ratingLowest' => 'Rating (Lowest)',
			'sort.dateAddedNewest' => 'Date Added (Newest)',
			'sort.dateAddedOldest' => 'Date Added (Oldest)',
			'search.search' => 'Search',
			'search.searchPlaceholder' => 'Search...',
			'search.searchForSomething' => 'Search for anything',
			'search.noResultsFound' => 'No results found',
			'search.cantSearch' => 'Can\'t search now',
			'details.title' => 'Details',
			'details.movies' => 'Movies',
			'details.series' => 'Series',
			'details.games' => 'Games',
			'details.books' => 'Books',
			'details.anime' => 'Anime',
			'details.manga' => 'Manga',
			'details.description' => 'Description',
			'details.genres' => 'Genre',
			'details.progressTracker' => 'Progress Tracker',
			'details.season' => 'Season',
			'details.episode' => 'Episode',
			'details.chapter' => 'Chapter',
			'details.volume' => 'Volume',
			'details.releaseDate' => 'Release Date',
			'details.platforms' => 'Platforms',
			'details.rating' => 'Rating',
			'details.publisher' => 'Publisher',
			'details.studio' => 'Studio',
			'details.network' => 'Network',
			'details.moreLikeThis' => 'More like this',
			'details.noRecommendations' => 'No Recommendations',
			'settings.backupAndRestore' => 'Backup & Restore',
			'settings.settings' => 'Settings',
			'settings.language' => 'Language',
			'settings.theme' => 'Theme',
			'settings.font' => 'Font',
			'settings.appDefaultFont' => 'App Default',
			'settings.systemFont' => 'System Default',
			'settings.customFont' => 'Custom Font',
			'settings.customFontDetails' => 'Custom Font Details',
			'settings.history' => 'History',
			'settings.apiChange' => 'Change API',
			'settings.statistics' => 'Statistics',
			'settings.about' => 'About',
			'settings.monthRolloverBehavior' => 'Month Rollover Behavior',
			'settings.monthRolloverBehaviorDescription' => 'Choose what happens at the start of a new month.',
			'settings.rolloverFull' => 'Full Rollover (Default)',
			'settings.rolloverFullDescription' => 'Move finished items to history and ask which to-do items to keep.',
			'settings.rolloverPartial' => 'Partial Rollover',
			'settings.rolloverPartialDescription' => 'Only move finished items to history. Keep all to-do items.',
			'settings.rolloverManual' => 'Manual',
			'settings.rolloverManualDescription' => 'Do nothing. I will manage my lists myself.',
			'settings.showSeriesTracker' => 'Show Series Tracker',
			'settings.showSeriesTrackerDescription' => 'Display current season and episode for TV series on the main lists.',
			'languageSettings.selectLanguage' => 'Select Language',
			'languageSettings.en' => 'English',
			'languageSettings.ar' => 'العربية',
			'themeSettings.themeSettings' => 'Theme Settings',
			'themeSettings.autoTheme' => 'Auto Theme',
			'themeSettings.manualTheme' => 'Manual Theme',
			'themeSettings.autoThemeDescription' => 'Automatically changes theme based on current month',
			'themeSettings.selectTheme' => 'Select Theme:',
			'fontSettings.title' => 'Font Settings',
			'fontSettings.change' => 'Change',
			'fontSettings.remove' => 'Remove',
			'fontSettings.noCustomFont' => 'No custom font selected',
			'fontSettings.selectFontFile' => 'Select Font File (.ttf, .otf)\'',
			'backupAndRestore.title' => 'Backup & Restore',
			'backupAndRestore.backupData' => 'Backup Data',
			'backupAndRestore.restoreData' => 'Restore Data',
			'backupAndRestore.backupDescription' => 'Save your current lists to a local file.',
			'backupAndRestore.restoreDescription' => 'Restore your lists from a previously saved backup file. This will overwrite current data.',
			'backupAndRestore.backupSuccessful' => 'Backup successful!',
			'backupAndRestore.backupFailed' => 'Backup failed: ',
			'backupAndRestore.restoreSuccessful' => 'Restore successful!',
			'backupAndRestore.restoreFailed' => 'Restore failed: ',
			'backupAndRestore.noFileSelected' => 'No file selected.',
			'backupAndRestore.invalidFileFormat' => 'Invalid backup file format or missing data.',
			'backupAndRestore.selectBackupFile' => 'Select Backup File',
			'backupAndRestore.saveBackupFile' => 'Save Backup File As',
			'backupAndRestore.defaultBackupFileName' => 'noted_backup.json',
			'backupAndRestore.yes' => 'Yes',
			'backupAndRestore.no' => 'No',
			'backupAndRestore.dataRestoredMessage' => 'Data restored successfully.',
			'history.history' => 'History',
			'history.item' => 'Item',
			'history.items' => 'Items',
			'history.noHistory' => 'No history yet',
			'apiSettings.gamesApiTitle' => 'Games API',
			'apiSettings.gamesApiDescription' => 'Get your API key from RAWG.io',
			'apiSettings.moviesApiTitle' => 'Movies & TV Series API',
			'apiSettings.moviesApiDescription' => 'Get your API key from The Movie Database',
			'apiSettings.booksApiTitle' => 'Books API',
			'apiSettings.booksApiDescription' => 'Get your API key from Google Cloud Console',
			'apiSettings.getApiKey' => 'Get API Key',
			'apiSettings.apiKey' => 'API Key',
			'apiSettings.save' => 'Save',
			'apiSettings.delete' => 'Delete',
			'statistics.thisMonth' => 'This Month',
			'statistics.allTime' => 'All Time',
			'statistics.totalItems' => 'Total Items',
			'statistics.category' => 'Category',
			'statistics.noData' => 'No data yet',
			'about.aboutThisApp' => 'About This App',
			'about.appDescription' => 'This app has been made for practice, so if you encounter any issue tell the developer on GitHub.',
			'about.reportIssue' => 'Issue?',
			'about.viewProject' => 'View Project',
			'about.apisUsed' => 'APIs Used',
			'about.gamesDescription' => 'Games data comes from RAWG site',
			'about.moviesAndTvSeries' => 'Movies and TV Series',
			'about.moviesAndTvSeriesDescription' => 'All data about movies and TV series comes from TMDB site',
			'about.booksDescription' => 'All data about books comes from Google Books API',
			'about.animeAndManga' => 'Anime & Manga',
			'about.animeAndMangaDescription' => 'Anime and manga data comes from Jikan API, no API key needed',
			'about.thanksMessage' => 'Thanks to their free plan, the app became usable as it is now.',
			_ => null,
		};
	}
}
