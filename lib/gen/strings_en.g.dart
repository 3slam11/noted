///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
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
	late final TranslationsQrSettingsEn qrSettings = TranslationsQrSettingsEn._(_root);
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
	String get noRouteFound => 'No Route Found';
}

// Path: errorHandler
class TranslationsErrorHandlerEn {
	TranslationsErrorHandlerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get defaultError => 'Something went wrong, try again later';
	String get success => 'Success';
	String get noContent => 'No Content';
	String get badRequest => 'Bad Request';
	String get unauthorized => 'Unauthorized';
	String get forbidden => 'Forbidden';
	String get internalServerError => 'Internal Server Error';
	String get notFound => 'Not Found';
	String get timeOut => 'Time Out';
	String get cancel => 'Cancel';
	String get cacheError => 'Cache Error';
	String get noInternetConnection => 'No Internet Connection';
	String get errorOccurred => 'An error occurred';
	String get connectionIssuesTitle => 'Connection Issues';
	String get connectionIssuesSubtitle => 'There might be several reasons for this issue:';
	String get internetNotWorking => 'Internet might be not working.';
	String get apiCapacityHit => 'Default API might have hit the capacity.';
	String get customApiError => 'Your custom API might be written incorrectly.';
	String get siteDownError => 'Site might be down at the moment, wait a few minutes and try later.';
}

// Path: stateRenderer
class TranslationsStateRendererEn {
	TranslationsStateRendererEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get content => 'Content';
	String get error => 'Error';
	String get loading => 'Loading';
	String get retry => 'Retry';
	String get ok => 'Ok';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get titleSection => 'Entertainment list for ';
	String get emptySection => 'This list is empty';
	String get finishedList => 'Finished List';
	String get movies => 'Movies';
	String get series => 'Series';
	String get games => 'Games';
	String get books => 'Books';
	String get all => 'All';
	String get deleted => 'Deleted';
	String get undo => 'Undo';
	String get newMonthStarted => 'New Month Started! 🎉';
	String description({required Object month}) => 'Welcome to ${month}!';
	String get description2 => 'Your finished items have been moved to history. Here are your unfinished items from last month:';
	String get pending => '📝 Pending: ';
	String get completed => '🎯 Completed: ';
	String get selectAll => 'Select All';
	String get deselectAll => 'Deselect All';
	String get deleteAll => 'Delete All';
	String get addAll => 'Add All';
	String get keepSelected => 'Keep Selected';
	String get noCompleted => 'No completed items yet';
	String get congratulations => 'Congratulations!';
	String get todosDone => 'You have completed everything last month!';
	String get close => 'Close';
	String get timeWrong => 'Either you\'re a time traveler or you messed with your date settings! 🕰️';
	String get timeWrongDescription => 'The app detected that your current date may be wrong. This could mess with your lists.';
	String get continueAnyway => 'Continue';
	String get itemActions => 'Item Actions';
	String get moveToTodo => 'Move to todo';
	String get moveToFinished => 'Move to finished';
	String get moveToHistory => 'Move to history';
	String get editNotes => 'Edit/View Notes';
	String get yourRating => 'Your Rating';
	String get yourNotes => 'Your Notes';
	String get notesHint => 'Add your thoughts here...';
	String get noNotes => 'No note yet.';
	String get notesSaved => 'Note saved.';
	String get save => 'Save';
	String get delete => 'Delete';
}

// Path: sort
class TranslationsSortEn {
	TranslationsSortEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get sort => 'Sort';
	String get sortBy => 'Sort by';
	String get titleAsc => 'Title (A-Z)';
	String get titleDesc => 'Title (Z-A)';
	String get releaseDateNewest => 'Release Date (Newest)';
	String get releaseDateOldest => 'Release Date (Oldest)';
	String get ratingHighest => 'Rating (Highest)';
	String get ratingLowest => 'Rating (Lowest)';
	String get dateAddedNewest => 'Date Added (Newest)';
	String get dateAddedOldest => 'Date Added (Oldest)';
}

// Path: search
class TranslationsSearchEn {
	TranslationsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get search => 'Search';
	String get searchPlaceholder => 'Search...';
	String get searchForSomething => 'Search for anything';
	String get noResultsFound => 'No results found';
	String get cantSearch => 'Can\'t search now';
}

// Path: details
class TranslationsDetailsEn {
	TranslationsDetailsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Details';
	String get movies => 'Movies';
	String get series => 'Series';
	String get games => 'Games';
	String get books => 'Books';
	String get description => 'Description';
	String get releaseDate => 'Release Date';
	String get platforms => 'Platforms';
	String get rating => 'Rating';
	String get publisher => 'Publisher';
	String get studio => 'Studio';
	String get network => 'Network';
	String get moreLikeThis => 'More like this';
	String get noRecommendations => 'No Recommendations';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get backupAndRestore => 'Backup & Restore';
	String get settings => 'Settings';
	String get language => 'Language';
	String get theme => 'Theme';
	String get font => 'Font';
	String get appDefaultFont => 'App Default';
	String get systemFont => 'System Default';
	String get customFont => 'Custom Font';
	String get customFontDetails => 'Custom Font Details';
	String get history => 'History';
	String get apiChange => 'Change API';
	String get statistics => 'Statistics';
	String get about => 'About';
}

// Path: qrSettings
class TranslationsQrSettingsEn {
	TranslationsQrSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'QR Code Sync';
	String get desktop => 'Feature Not Available on Desktop';
	String get desktopDescription => 'QR code scanning is only available on the mobile version of the app.';
	String get subtitle => 'Sync between devices with a QR code';
	String get description => 'You can export and import your data and settings with QR code to another device.';
	String get alert => 'Importing will overwrite all current settings and lists.';
	String get scan => 'Scan';
	String get generate => 'Generate';
	String get generating => 'Generating QR Code...';
	String get generated => 'QR Code Generated';
}

// Path: languageSettings
class TranslationsLanguageSettingsEn {
	TranslationsLanguageSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get selectLanguage => 'Select Language';
	String get en => 'English';
	String get ar => 'العربية';
}

// Path: themeSettings
class TranslationsThemeSettingsEn {
	TranslationsThemeSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get themeSettings => 'Theme Settings';
	String get autoTheme => 'Auto Theme';
	String get manualTheme => 'Manual Theme';
	String get autoThemeDescription => 'Automatically changes theme based on current month';
	String get selectTheme => 'Select Theme:';
}

// Path: fontSettings
class TranslationsFontSettingsEn {
	TranslationsFontSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Font Settings';
	String get change => 'Change';
	String get remove => 'Remove';
	String get noCustomFont => 'No custom font selected';
	String get selectFontFile => 'Select Font File (.ttf, .otf)\'';
}

// Path: backupAndRestore
class TranslationsBackupAndRestoreEn {
	TranslationsBackupAndRestoreEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Backup & Restore';
	String get backupData => 'Backup Data';
	String get restoreData => 'Restore Data';
	String get backupDescription => 'Save your current lists to a local file.';
	String get restoreDescription => 'Restore your lists from a previously saved backup file. This will overwrite current data.';
	String get backupSuccessful => 'Backup successful!';
	String get backupFailed => 'Backup failed: ';
	String get restoreSuccessful => 'Restore successful!';
	String get restoreFailed => 'Restore failed: ';
	String get noFileSelected => 'No file selected.';
	String get invalidFileFormat => 'Invalid backup file format or missing data.';
	String get selectBackupFile => 'Select Backup File';
	String get saveBackupFile => 'Save Backup File As';
	String get defaultBackupFileName => 'noted_backup.json';
	String get yes => 'Yes';
	String get no => 'No';
	String get dataRestoredMessage => 'Data restored successfully.';
}

// Path: history
class TranslationsHistoryEn {
	TranslationsHistoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get history => 'History';
	String get item => 'Item';
	String get items => 'Items';
	String get noHistory => 'No history yet';
}

// Path: apiSettings
class TranslationsApiSettingsEn {
	TranslationsApiSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get gamesApiTitle => 'Games API';
	String get gamesApiDescription => 'Get your API key from RAWG.io';
	String get moviesApiTitle => 'Movies & TV Series API';
	String get moviesApiDescription => 'Get your API key from The Movie Database';
	String get booksApiTitle => 'Books API';
	String get booksApiDescription => 'Get your API key from Google Cloud Console';
	String get getApiKey => 'Get API Key';
	String get apiKey => 'API Key';
	String get save => 'Save';
	String get delete => 'Delete';
}

// Path: statistics
class TranslationsStatisticsEn {
	TranslationsStatisticsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get thisMonth => 'This Month';
	String get allTime => 'All Time';
	String get totalItems => 'Total Items';
	String get category => 'Category';
	String get noData => 'No data yet';
}

// Path: about
class TranslationsAboutEn {
	TranslationsAboutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get aboutThisApp => 'About This App';
	String get appDescription => 'This app has been made for practice, so if you encounter any issue tell the developer on GitHub.';
	String get apisUsed => 'APIs Used';
	String get gamesDescription => 'Games data came from RAWG site';
	String get moviesAndTvSeries => 'Movies and TV Series';
	String get moviesAndTvSeriesDescription => 'All data about movies and TV series came from TMDB site';
	String get booksDescription => 'All data about books came from Google Books API';
	String get thanksMessage => 'Thanks to their free plan, the app became usable as it is now.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appName': return 'Noted';
			case 'months.0': return 'January';
			case 'months.1': return 'February';
			case 'months.2': return 'March';
			case 'months.3': return 'April';
			case 'months.4': return 'May';
			case 'months.5': return 'June';
			case 'months.6': return 'July';
			case 'months.7': return 'August';
			case 'months.8': return 'September';
			case 'months.9': return 'October';
			case 'months.10': return 'November';
			case 'months.11': return 'December';
			case 'routes.noRouteFound': return 'No Route Found';
			case 'errorHandler.defaultError': return 'Something went wrong, try again later';
			case 'errorHandler.success': return 'Success';
			case 'errorHandler.noContent': return 'No Content';
			case 'errorHandler.badRequest': return 'Bad Request';
			case 'errorHandler.unauthorized': return 'Unauthorized';
			case 'errorHandler.forbidden': return 'Forbidden';
			case 'errorHandler.internalServerError': return 'Internal Server Error';
			case 'errorHandler.notFound': return 'Not Found';
			case 'errorHandler.timeOut': return 'Time Out';
			case 'errorHandler.cancel': return 'Cancel';
			case 'errorHandler.cacheError': return 'Cache Error';
			case 'errorHandler.noInternetConnection': return 'No Internet Connection';
			case 'errorHandler.errorOccurred': return 'An error occurred';
			case 'errorHandler.connectionIssuesTitle': return 'Connection Issues';
			case 'errorHandler.connectionIssuesSubtitle': return 'There might be several reasons for this issue:';
			case 'errorHandler.internetNotWorking': return 'Internet might be not working.';
			case 'errorHandler.apiCapacityHit': return 'Default API might have hit the capacity.';
			case 'errorHandler.customApiError': return 'Your custom API might be written incorrectly.';
			case 'errorHandler.siteDownError': return 'Site might be down at the moment, wait a few minutes and try later.';
			case 'stateRenderer.content': return 'Content';
			case 'stateRenderer.error': return 'Error';
			case 'stateRenderer.loading': return 'Loading';
			case 'stateRenderer.retry': return 'Retry';
			case 'stateRenderer.ok': return 'Ok';
			case 'home.titleSection': return 'Entertainment list for ';
			case 'home.emptySection': return 'This list is empty';
			case 'home.finishedList': return 'Finished List';
			case 'home.movies': return 'Movies';
			case 'home.series': return 'Series';
			case 'home.games': return 'Games';
			case 'home.books': return 'Books';
			case 'home.all': return 'All';
			case 'home.deleted': return 'Deleted';
			case 'home.undo': return 'Undo';
			case 'home.newMonthStarted': return 'New Month Started! 🎉';
			case 'home.description': return ({required Object month}) => 'Welcome to ${month}!';
			case 'home.description2': return 'Your finished items have been moved to history. Here are your unfinished items from last month:';
			case 'home.pending': return '📝 Pending: ';
			case 'home.completed': return '🎯 Completed: ';
			case 'home.selectAll': return 'Select All';
			case 'home.deselectAll': return 'Deselect All';
			case 'home.deleteAll': return 'Delete All';
			case 'home.addAll': return 'Add All';
			case 'home.keepSelected': return 'Keep Selected';
			case 'home.noCompleted': return 'No completed items yet';
			case 'home.congratulations': return 'Congratulations!';
			case 'home.todosDone': return 'You have completed everything last month!';
			case 'home.close': return 'Close';
			case 'home.timeWrong': return 'Either you\'re a time traveler or you messed with your date settings! 🕰️';
			case 'home.timeWrongDescription': return 'The app detected that your current date may be wrong. This could mess with your lists.';
			case 'home.continueAnyway': return 'Continue';
			case 'home.itemActions': return 'Item Actions';
			case 'home.moveToTodo': return 'Move to todo';
			case 'home.moveToFinished': return 'Move to finished';
			case 'home.moveToHistory': return 'Move to history';
			case 'home.editNotes': return 'Edit/View Notes';
			case 'home.yourRating': return 'Your Rating';
			case 'home.yourNotes': return 'Your Notes';
			case 'home.notesHint': return 'Add your thoughts here...';
			case 'home.noNotes': return 'No note yet.';
			case 'home.notesSaved': return 'Note saved.';
			case 'home.save': return 'Save';
			case 'home.delete': return 'Delete';
			case 'sort.sort': return 'Sort';
			case 'sort.sortBy': return 'Sort by';
			case 'sort.titleAsc': return 'Title (A-Z)';
			case 'sort.titleDesc': return 'Title (Z-A)';
			case 'sort.releaseDateNewest': return 'Release Date (Newest)';
			case 'sort.releaseDateOldest': return 'Release Date (Oldest)';
			case 'sort.ratingHighest': return 'Rating (Highest)';
			case 'sort.ratingLowest': return 'Rating (Lowest)';
			case 'sort.dateAddedNewest': return 'Date Added (Newest)';
			case 'sort.dateAddedOldest': return 'Date Added (Oldest)';
			case 'search.search': return 'Search';
			case 'search.searchPlaceholder': return 'Search...';
			case 'search.searchForSomething': return 'Search for anything';
			case 'search.noResultsFound': return 'No results found';
			case 'search.cantSearch': return 'Can\'t search now';
			case 'details.title': return 'Details';
			case 'details.movies': return 'Movies';
			case 'details.series': return 'Series';
			case 'details.games': return 'Games';
			case 'details.books': return 'Books';
			case 'details.description': return 'Description';
			case 'details.releaseDate': return 'Release Date';
			case 'details.platforms': return 'Platforms';
			case 'details.rating': return 'Rating';
			case 'details.publisher': return 'Publisher';
			case 'details.studio': return 'Studio';
			case 'details.network': return 'Network';
			case 'details.moreLikeThis': return 'More like this';
			case 'details.noRecommendations': return 'No Recommendations';
			case 'settings.backupAndRestore': return 'Backup & Restore';
			case 'settings.settings': return 'Settings';
			case 'settings.language': return 'Language';
			case 'settings.theme': return 'Theme';
			case 'settings.font': return 'Font';
			case 'settings.appDefaultFont': return 'App Default';
			case 'settings.systemFont': return 'System Default';
			case 'settings.customFont': return 'Custom Font';
			case 'settings.customFontDetails': return 'Custom Font Details';
			case 'settings.history': return 'History';
			case 'settings.apiChange': return 'Change API';
			case 'settings.statistics': return 'Statistics';
			case 'settings.about': return 'About';
			case 'qrSettings.title': return 'QR Code Sync';
			case 'qrSettings.desktop': return 'Feature Not Available on Desktop';
			case 'qrSettings.desktopDescription': return 'QR code scanning is only available on the mobile version of the app.';
			case 'qrSettings.subtitle': return 'Sync between devices with a QR code';
			case 'qrSettings.description': return 'You can export and import your data and settings with QR code to another device.';
			case 'qrSettings.alert': return 'Importing will overwrite all current settings and lists.';
			case 'qrSettings.scan': return 'Scan';
			case 'qrSettings.generate': return 'Generate';
			case 'qrSettings.generating': return 'Generating QR Code...';
			case 'qrSettings.generated': return 'QR Code Generated';
			case 'languageSettings.selectLanguage': return 'Select Language';
			case 'languageSettings.en': return 'English';
			case 'languageSettings.ar': return 'العربية';
			case 'themeSettings.themeSettings': return 'Theme Settings';
			case 'themeSettings.autoTheme': return 'Auto Theme';
			case 'themeSettings.manualTheme': return 'Manual Theme';
			case 'themeSettings.autoThemeDescription': return 'Automatically changes theme based on current month';
			case 'themeSettings.selectTheme': return 'Select Theme:';
			case 'fontSettings.title': return 'Font Settings';
			case 'fontSettings.change': return 'Change';
			case 'fontSettings.remove': return 'Remove';
			case 'fontSettings.noCustomFont': return 'No custom font selected';
			case 'fontSettings.selectFontFile': return 'Select Font File (.ttf, .otf)\'';
			case 'backupAndRestore.title': return 'Backup & Restore';
			case 'backupAndRestore.backupData': return 'Backup Data';
			case 'backupAndRestore.restoreData': return 'Restore Data';
			case 'backupAndRestore.backupDescription': return 'Save your current lists to a local file.';
			case 'backupAndRestore.restoreDescription': return 'Restore your lists from a previously saved backup file. This will overwrite current data.';
			case 'backupAndRestore.backupSuccessful': return 'Backup successful!';
			case 'backupAndRestore.backupFailed': return 'Backup failed: ';
			case 'backupAndRestore.restoreSuccessful': return 'Restore successful!';
			case 'backupAndRestore.restoreFailed': return 'Restore failed: ';
			case 'backupAndRestore.noFileSelected': return 'No file selected.';
			case 'backupAndRestore.invalidFileFormat': return 'Invalid backup file format or missing data.';
			case 'backupAndRestore.selectBackupFile': return 'Select Backup File';
			case 'backupAndRestore.saveBackupFile': return 'Save Backup File As';
			case 'backupAndRestore.defaultBackupFileName': return 'noted_backup.json';
			case 'backupAndRestore.yes': return 'Yes';
			case 'backupAndRestore.no': return 'No';
			case 'backupAndRestore.dataRestoredMessage': return 'Data restored successfully.';
			case 'history.history': return 'History';
			case 'history.item': return 'Item';
			case 'history.items': return 'Items';
			case 'history.noHistory': return 'No history yet';
			case 'apiSettings.gamesApiTitle': return 'Games API';
			case 'apiSettings.gamesApiDescription': return 'Get your API key from RAWG.io';
			case 'apiSettings.moviesApiTitle': return 'Movies & TV Series API';
			case 'apiSettings.moviesApiDescription': return 'Get your API key from The Movie Database';
			case 'apiSettings.booksApiTitle': return 'Books API';
			case 'apiSettings.booksApiDescription': return 'Get your API key from Google Cloud Console';
			case 'apiSettings.getApiKey': return 'Get API Key';
			case 'apiSettings.apiKey': return 'API Key';
			case 'apiSettings.save': return 'Save';
			case 'apiSettings.delete': return 'Delete';
			case 'statistics.thisMonth': return 'This Month';
			case 'statistics.allTime': return 'All Time';
			case 'statistics.totalItems': return 'Total Items';
			case 'statistics.category': return 'Category';
			case 'statistics.noData': return 'No data yet';
			case 'about.aboutThisApp': return 'About This App';
			case 'about.appDescription': return 'This app has been made for practice, so if you encounter any issue tell the developer on GitHub.';
			case 'about.apisUsed': return 'APIs Used';
			case 'about.gamesDescription': return 'Games data came from RAWG site';
			case 'about.moviesAndTvSeries': return 'Movies and TV Series';
			case 'about.moviesAndTvSeriesDescription': return 'All data about movies and TV series came from TMDB site';
			case 'about.booksDescription': return 'All data about books came from Google Books API';
			case 'about.thanksMessage': return 'Thanks to their free plan, the app became usable as it is now.';
			default: return null;
		}
	}
}

