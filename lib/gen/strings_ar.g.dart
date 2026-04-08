///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'نوتد';
	@override List<String> get months => [
		'يناير',
		'فبراير',
		'مارس',
		'أبريل',
		'مايو',
		'يونيو',
		'يوليو',
		'اغسطس',
		'سبتمبر',
		'أكتوبر',
		'نوفمبر',
		'ديسمبر',
	];
	@override late final _TranslationsRoutesAr routes = _TranslationsRoutesAr._(_root);
	@override late final _TranslationsErrorHandlerAr errorHandler = _TranslationsErrorHandlerAr._(_root);
	@override late final _TranslationsStateRendererAr stateRenderer = _TranslationsStateRendererAr._(_root);
	@override late final _TranslationsHomeAr home = _TranslationsHomeAr._(_root);
	@override late final _TranslationsSortAr sort = _TranslationsSortAr._(_root);
	@override late final _TranslationsSearchAr search = _TranslationsSearchAr._(_root);
	@override late final _TranslationsDetailsAr details = _TranslationsDetailsAr._(_root);
	@override late final _TranslationsSettingsAr settings = _TranslationsSettingsAr._(_root);
	@override late final _TranslationsLanguageSettingsAr languageSettings = _TranslationsLanguageSettingsAr._(_root);
	@override late final _TranslationsThemeSettingsAr themeSettings = _TranslationsThemeSettingsAr._(_root);
	@override late final _TranslationsFontSettingsAr fontSettings = _TranslationsFontSettingsAr._(_root);
	@override late final _TranslationsBackupAndRestoreAr backupAndRestore = _TranslationsBackupAndRestoreAr._(_root);
	@override late final _TranslationsHistoryAr history = _TranslationsHistoryAr._(_root);
	@override late final _TranslationsApiSettingsAr apiSettings = _TranslationsApiSettingsAr._(_root);
	@override late final _TranslationsStatisticsAr statistics = _TranslationsStatisticsAr._(_root);
	@override late final _TranslationsAboutAr about = _TranslationsAboutAr._(_root);
}

// Path: routes
class _TranslationsRoutesAr implements TranslationsRoutesEn {
	_TranslationsRoutesAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get noRouteFound => 'المسار غير موجود';
}

// Path: errorHandler
class _TranslationsErrorHandlerAr implements TranslationsErrorHandlerEn {
	_TranslationsErrorHandlerAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get defaultError => 'حدث خطأ ما، حاول مرة أخرى لاحقاً';
	@override String get success => 'نجاح';
	@override String get noContent => 'لا يوجد محتوى';
	@override String get badRequest => 'طلب سيء';
	@override String get unauthorized => 'غير مصرح به';
	@override String get forbidden => 'ممنوع';
	@override String get internalServerError => 'خطأ في الخادم الداخلي';
	@override String get notFound => 'غير موجود';
	@override String get timeOut => 'انقضى الوقت';
	@override String get cancel => 'إلغاء';
	@override String get cacheError => 'خطأ في الكاش';
	@override String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';
	@override String get errorOccurred => 'حدث خطأ';
	@override String get connectionIssuesTitle => 'مشاكل الاتصال';
	@override String get connectionIssuesSubtitle => 'قد تكون هناك عدة أسباب لهذه المشكلة:';
	@override String get internetNotWorking => 'ربما الإنترنت لا يعمل.';
	@override String get apiCapacityHit => 'قد تكون سعة واجهة برمجة التطبيقات الافتراضية قد وصلت إلى الحد الأقصى.';
	@override String get customApiError => 'قد تكون واجهة برمجة التطبيقات المخصصة الخاصة بك مكتوبة بشكل غير صحيح.';
	@override String get siteDownError => 'قد يكون الموقع معطلاً في الوقت الحالي، انتظر بضع دقائق وحاول لاحقًا.';
}

// Path: stateRenderer
class _TranslationsStateRendererAr implements TranslationsStateRendererEn {
	_TranslationsStateRendererAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get content => 'المحتوى';
	@override String get error => 'خطأ';
	@override String get loading => 'تحميل';
	@override String get retry => 'إعادة المحاولة';
	@override String get ok => 'موافق';
}

// Path: home
class _TranslationsHomeAr implements TranslationsHomeEn {
	_TranslationsHomeAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get titleSection => 'قائمة الترفيه لشهر ';
	@override String get emptySection => 'القائمة فارغة';
	@override String get finishedList => 'القائمة المكتملة';
	@override String get savedList => 'المحفوظات';
	@override String get movies => 'الأفلام';
	@override String get series => 'المسلسلات';
	@override String get games => 'الألعاب';
	@override String get books => 'الكتب';
	@override String get anime => 'الأنمي';
	@override String get manga => 'المانجا';
	@override String get all => 'الكل';
	@override String get deleted => 'حذفت';
	@override String get undo => 'تراجع';
	@override String get newMonthStarted => 'بدأ شهر جديد! 🎉';
	@override String description({required Object month}) => 'مرحبا بـ ${month}!';
	@override String get description2 => 'تم نقل العناصر المكتملة للسجل. هذه هي العناصر المتبقية من الشهر الماضي:';
	@override String get pending => 'المهام';
	@override String get completed => 'المكتمل';
	@override String get selectAll => 'تحديد الكل';
	@override String get deselectAll => 'إلغاء تحديد الكل';
	@override String get deleteAll => 'حذف الكل';
	@override String get addAll => 'اضف الكل';
	@override String get keepSelected => 'الاحتفاظ بالمحدد';
	@override String get noCompleted => 'لا يوجد عناصر مكتملة حتى الآن';
	@override String get noSaved => 'لا توجد عناصر محفوظة حتى الآن';
	@override String get congratulations => 'تهانينا!';
	@override String get todosDone => 'لقد اكملت كل عناصر الشهر الماضي!';
	@override String get close => 'اغلاق';
	@override String get timeWrong => 'إما انك مسافر بالزمن أو قمت بتغيير التاريخ! 🕰️';
	@override String get timeWrongDescription => 'التطبيق لاحظ ان تاريخ هاتفك ربما لا يكون صحيحاً. هذا قد يعبث بالقوائم.';
	@override String get continueAnyway => 'استمر';
	@override String get itemActions => 'اختيارات العنصر';
	@override String get moveToTodo => 'نقل لقائمة المهام';
	@override String get moveToFinished => 'نقل للقائمة المكتملة';
	@override String get moveToHistory => 'نقل للسجل';
	@override String get moveToSaved => 'نقل لقائمة الحفظ';
	@override String get addToTodo => 'أضف لقائمة المهام';
	@override String get addToSaved => 'أضف لقائمة الحفظ';
	@override String get editNotes => 'تعديل/عرض الملاحظات';
	@override String get yourRating => 'تقييمك';
	@override String get yourNotes => 'ملاحظاتك';
	@override String get notesHint => 'أضف أفكارك هنا...';
	@override String get noNotes => 'لا توجد ملاحظات بعد.';
	@override String get notesSaved => 'تم حفظ الملاحظات والتقييم.';
	@override String get save => 'حفظ';
	@override String get delete => 'حذف';
	@override String get addManualItem => 'اضف يدوياً';
	@override String get basicInformation => 'معلومات اساسية';
	@override String get media => 'وسائط';
	@override String get additionalDetails => 'معلومات إضافية';
	@override String get titleRequired => 'العنوان مطلوب';
	@override String get titleHint => 'العنوان';
	@override String get descriptionOptional => 'الوصف (اختياري)';
	@override String get imageUrlOptional => 'البوستر (اختياري)';
	@override String get additionalImagesOptional => 'صور إضافية (روابط مفصولة بفاصلة)';
	@override String get releaseDateOptional => 'تاريخ الإصدار (اختياري)';
	@override String get selectList => 'أضف إلى قائمة';
	@override String get pickImage => 'اختر صورة';
	@override String get removeImage => 'إزالة الصورة';
	@override String get genresOptional => 'التصنيفات (مفصولة بفاصلة)';
	@override String get publisherOptional => 'الناشر / الاستوديو (اختياري)';
	@override String get platformsOptional => 'المنصات (مفصولة بفاصلة)';
}

// Path: sort
class _TranslationsSortAr implements TranslationsSortEn {
	_TranslationsSortAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get sort => 'رتب';
	@override String get sortBy => 'ترتيب حسب';
	@override String get title => 'العنوان';
	@override String get releaseDate => 'تاريخ الإصدار';
	@override String get rating => 'التقييم';
	@override String get dateAdded => 'تاريخ الإضافة';
}

// Path: search
class _TranslationsSearchAr implements TranslationsSearchEn {
	_TranslationsSearchAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get search => 'بحث';
	@override String get searchPlaceholder => 'ابحث...';
	@override String get searchOrAdd => 'ابحث عن أي شيء\n\nأو';
	@override String get noResultsFound => 'لم يتم العثور على نتائج. يمكنك إضافته يدوياً.';
	@override String get cantSearch => 'لا يمكن البحث الآن';
}

// Path: details
class _TranslationsDetailsAr implements TranslationsDetailsEn {
	_TranslationsDetailsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تفاصيل';
	@override String get movies => 'الأفلام';
	@override String get series => 'المسلسلات';
	@override String get games => 'الألعاب';
	@override String get books => 'الكتب';
	@override String get anime => 'الأنمي';
	@override String get manga => 'المانجا';
	@override String get description => 'الوصف';
	@override String get genres => 'التصنيف';
	@override String get progressTracker => 'تتبع التقدم';
	@override String get season => 'الموسم';
	@override String get episode => 'الحلقة';
	@override String get chapter => 'الفصل';
	@override String get volume => 'المجلد';
	@override String get releaseDate => 'تاريخ الإصدار';
	@override String get platforms => 'المنصات';
	@override String get rating => 'التقييم';
	@override String get publisher => 'الناشر';
	@override String get studio => 'الشركة';
	@override String get network => 'الشبكة';
	@override String get moreLikeThis => 'مثل هذا';
	@override String get noRecommendations => 'لا توجد اقتراحات';
}

// Path: settings
class _TranslationsSettingsAr implements TranslationsSettingsEn {
	_TranslationsSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get backupAndRestore => 'النسخ والاستعادة';
	@override String get settings => 'الإعدادات';
	@override String get language => 'اللغة';
	@override String get theme => 'السمة';
	@override String get font => 'الخط';
	@override String get appDefaultFont => 'الخط الافتراضي';
	@override String get systemFont => 'خط النظام';
	@override String get customFont => 'خط مخصص';
	@override String get customFontDetails => 'تفاصيل الخط المخصص';
	@override String get history => 'السجل';
	@override String get apiChange => 'تغيير الـAPI';
	@override String get statistics => 'الإحصائيات';
	@override String get about => 'حول التطبيق';
	@override String get monthRolloverBehavior => 'سلوك ترحيل الشهر';
	@override String get monthRolloverBehaviorDescription => 'اختر ما يحدث في بداية شهر جديد.';
	@override String get rolloverFull => 'ترحيل كامل (افتراضي)';
	@override String get rolloverFullDescription => 'نقل العناصر المكتملة إلى السجل والسؤال عن العناصر التي يجب الاحتفاظ بها في قائمة المهام.';
	@override String get rolloverPartial => 'ترحيل جزئي';
	@override String get rolloverPartialDescription => 'نقل العناصر المكتملة فقط إلى السجل. الاحتفاظ بجميع عناصر قائمة المهام.';
	@override String get rolloverManual => 'يدوي';
	@override String get rolloverManualDescription => 'لا تفعل شيئًا. سأدير قوائمي بنفسي.';
	@override String get showSeriesTracker => 'إظهار متتبع المسلسلات';
	@override String get showSeriesTrackerDescription => 'عرض الموسم والحلقة الحالية للمسلسلات التلفزيونية في القوائم الرئيسية.';
	@override String get showFilterToggle => 'فلتر قابل للطي';
	@override String get showFilterToggleDescription => 'إضافة زر في الشريط العلوي لإخفاء/إظهار الفلتر.';
}

// Path: languageSettings
class _TranslationsLanguageSettingsAr implements TranslationsLanguageSettingsEn {
	_TranslationsLanguageSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get selectLanguage => 'اختر اللغة';
	@override String get en => 'English';
	@override String get ar => 'العربية';
}

// Path: themeSettings
class _TranslationsThemeSettingsAr implements TranslationsThemeSettingsEn {
	_TranslationsThemeSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get themeSettings => 'إعدادات السمة';
	@override String get autoTheme => 'السمة التلقائية';
	@override String get manualTheme => 'السمة اليدوية';
	@override String get autoThemeDescription => 'تتغير السمة تلقائياً بناءً على الشهر الحالي';
	@override String get selectTheme => 'اختر السمة:';
}

// Path: fontSettings
class _TranslationsFontSettingsAr implements TranslationsFontSettingsEn {
	_TranslationsFontSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'إعدادات الخط';
	@override String get change => 'تغيير';
	@override String get remove => 'إزالة';
	@override String get noCustomFont => 'لم يتم تحديد خط مخصص';
	@override String get selectFontFile => 'اختر ملف الخط (.ttf, .otf)\'';
}

// Path: backupAndRestore
class _TranslationsBackupAndRestoreAr implements TranslationsBackupAndRestoreEn {
	_TranslationsBackupAndRestoreAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'النسخ الإحتياطي والاستعادة';
	@override String get backupData => 'النسخ الإحتياطي للبيانات';
	@override String get restoreData => 'إستعادة البيانات';
	@override String get backupDescription => 'حفظ القوائم الحالية في ملف.';
	@override String get restoreDescription => ' استعادة القوائم من الملف المحفوظ.';
	@override String get backupSuccessful => 'تم النسخ الإحتياطي بنجاح!';
	@override String get backupFailed => 'فشل النسخ الإحتياطي: ';
	@override String get restoreSuccessful => 'تم استعادة البيانات بنجاح!';
	@override String get restoreFailed => 'فشل استعادة البيانات: ';
	@override String get noFileSelected => 'لم يتم اختيار ملف.';
	@override String get invalidFileFormat => 'الملف غير صحيح او لا يوجد بيانات.';
	@override String get selectBackupFile => 'اختر ملف النسخ الإحتياطي';
	@override String get saveBackupFile => 'حفظ ملف النسخ الإحتياطي';
	@override String get defaultBackupFileName => 'noted_backup.json';
	@override String get yes => 'نعم';
	@override String get no => 'لا';
	@override String get dataRestoredMessage => 'تم استعادة البيانات بنجاح.';
}

// Path: history
class _TranslationsHistoryAr implements TranslationsHistoryEn {
	_TranslationsHistoryAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get history => 'السجل';
	@override String get item => 'عنصر';
	@override String get items => 'عناصر';
	@override String get noHistory => 'لا يوجد سجل حتى الان';
}

// Path: apiSettings
class _TranslationsApiSettingsAr implements TranslationsApiSettingsEn {
	_TranslationsApiSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get gamesApiTitle => 'الـAPI الخاص بالإلعاب';
	@override String get gamesApiDescription => 'احصل على الـAPI الخاص بك من RAWG.io';
	@override String get moviesApiTitle => 'الـAPI الخاص بالأفلام والمسلسلات';
	@override String get moviesApiDescription => 'احصل على الـAPI الخاص بك من The Movie Database';
	@override String get booksApiTitle => 'الـAPI الخاص بالكتب';
	@override String get booksApiDescription => 'احصل على الـAPI الخاص بك من Google Cloud Console';
	@override String get getApiKey => 'احصل على الـ API';
	@override String get apiKey => 'مفتاح API';
	@override String get save => 'حفظ';
	@override String get delete => 'حذف';
}

// Path: statistics
class _TranslationsStatisticsAr implements TranslationsStatisticsEn {
	_TranslationsStatisticsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get thisMonth => 'هذا الشهر';
	@override String get allTime => 'كل الأوقات';
	@override String get totalItems => 'إجمالي العناصر';
	@override String get category => 'الفئات';
	@override String get noData => 'لا يوجد بيانات حتى الان';
}

// Path: about
class _TranslationsAboutAr implements TranslationsAboutEn {
	_TranslationsAboutAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get aboutThisApp => 'حول هذا التطبيق';
	@override String get appDescription => 'هذا التطبيق اٌنشئ بغرض التدريب فإذا واجهت مشكلة، ابلغ المطور على Github.';
	@override String get reportIssue => 'مشكلة؟';
	@override String get viewProject => 'صفحة التطبيق';
	@override String get apisUsed => 'الـAPIs المستخدمة';
	@override String get gamesDescription => 'بيانات الألعاب جاءت من موقع RAWG';
	@override String get moviesAndTvSeries => 'الأفلام والمسلسلات التلفزيونية';
	@override String get moviesAndTvSeriesDescription => 'جميع البيانات حول الأفلام والمسلسلات التلفزيونية جاءت من موقع TMDB';
	@override String get booksDescription => 'جميع البيانات حول الكتب جاءت من موقع Google Books API';
	@override String get animeAndManga => 'الأنمي والمانجا';
	@override String get animeAndMangaDescription => 'بيانات الأنمي والمانجا جاءت من Jikan, لا حاجة لـAPI';
	@override String get thanksMessage => 'بفضل خطتهم المجانية، أصبح التطبيق قابلًا للاستخدام كما هو الآن.';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'نوتد',
			'months.0' => 'يناير',
			'months.1' => 'فبراير',
			'months.2' => 'مارس',
			'months.3' => 'أبريل',
			'months.4' => 'مايو',
			'months.5' => 'يونيو',
			'months.6' => 'يوليو',
			'months.7' => 'اغسطس',
			'months.8' => 'سبتمبر',
			'months.9' => 'أكتوبر',
			'months.10' => 'نوفمبر',
			'months.11' => 'ديسمبر',
			'routes.noRouteFound' => 'المسار غير موجود',
			'errorHandler.defaultError' => 'حدث خطأ ما، حاول مرة أخرى لاحقاً',
			'errorHandler.success' => 'نجاح',
			'errorHandler.noContent' => 'لا يوجد محتوى',
			'errorHandler.badRequest' => 'طلب سيء',
			'errorHandler.unauthorized' => 'غير مصرح به',
			'errorHandler.forbidden' => 'ممنوع',
			'errorHandler.internalServerError' => 'خطأ في الخادم الداخلي',
			'errorHandler.notFound' => 'غير موجود',
			'errorHandler.timeOut' => 'انقضى الوقت',
			'errorHandler.cancel' => 'إلغاء',
			'errorHandler.cacheError' => 'خطأ في الكاش',
			'errorHandler.noInternetConnection' => 'لا يوجد اتصال بالإنترنت',
			'errorHandler.errorOccurred' => 'حدث خطأ',
			'errorHandler.connectionIssuesTitle' => 'مشاكل الاتصال',
			'errorHandler.connectionIssuesSubtitle' => 'قد تكون هناك عدة أسباب لهذه المشكلة:',
			'errorHandler.internetNotWorking' => 'ربما الإنترنت لا يعمل.',
			'errorHandler.apiCapacityHit' => 'قد تكون سعة واجهة برمجة التطبيقات الافتراضية قد وصلت إلى الحد الأقصى.',
			'errorHandler.customApiError' => 'قد تكون واجهة برمجة التطبيقات المخصصة الخاصة بك مكتوبة بشكل غير صحيح.',
			'errorHandler.siteDownError' => 'قد يكون الموقع معطلاً في الوقت الحالي، انتظر بضع دقائق وحاول لاحقًا.',
			'stateRenderer.content' => 'المحتوى',
			'stateRenderer.error' => 'خطأ',
			'stateRenderer.loading' => 'تحميل',
			'stateRenderer.retry' => 'إعادة المحاولة',
			'stateRenderer.ok' => 'موافق',
			'home.home' => 'الرئيسية',
			'home.titleSection' => 'قائمة الترفيه لشهر ',
			'home.emptySection' => 'القائمة فارغة',
			'home.finishedList' => 'القائمة المكتملة',
			'home.savedList' => 'المحفوظات',
			'home.movies' => 'الأفلام',
			'home.series' => 'المسلسلات',
			'home.games' => 'الألعاب',
			'home.books' => 'الكتب',
			'home.anime' => 'الأنمي',
			'home.manga' => 'المانجا',
			'home.all' => 'الكل',
			'home.deleted' => 'حذفت',
			'home.undo' => 'تراجع',
			'home.newMonthStarted' => 'بدأ شهر جديد! 🎉',
			'home.description' => ({required Object month}) => 'مرحبا بـ ${month}!',
			'home.description2' => 'تم نقل العناصر المكتملة للسجل. هذه هي العناصر المتبقية من الشهر الماضي:',
			'home.pending' => 'المهام',
			'home.completed' => 'المكتمل',
			'home.selectAll' => 'تحديد الكل',
			'home.deselectAll' => 'إلغاء تحديد الكل',
			'home.deleteAll' => 'حذف الكل',
			'home.addAll' => 'اضف الكل',
			'home.keepSelected' => 'الاحتفاظ بالمحدد',
			'home.noCompleted' => 'لا يوجد عناصر مكتملة حتى الآن',
			'home.noSaved' => 'لا توجد عناصر محفوظة حتى الآن',
			'home.congratulations' => 'تهانينا!',
			'home.todosDone' => 'لقد اكملت كل عناصر الشهر الماضي!',
			'home.close' => 'اغلاق',
			'home.timeWrong' => 'إما انك مسافر بالزمن أو قمت بتغيير التاريخ! 🕰️',
			'home.timeWrongDescription' => 'التطبيق لاحظ ان تاريخ هاتفك ربما لا يكون صحيحاً. هذا قد يعبث بالقوائم.',
			'home.continueAnyway' => 'استمر',
			'home.itemActions' => 'اختيارات العنصر',
			'home.moveToTodo' => 'نقل لقائمة المهام',
			'home.moveToFinished' => 'نقل للقائمة المكتملة',
			'home.moveToHistory' => 'نقل للسجل',
			'home.moveToSaved' => 'نقل لقائمة الحفظ',
			'home.addToTodo' => 'أضف لقائمة المهام',
			'home.addToSaved' => 'أضف لقائمة الحفظ',
			'home.editNotes' => 'تعديل/عرض الملاحظات',
			'home.yourRating' => 'تقييمك',
			'home.yourNotes' => 'ملاحظاتك',
			'home.notesHint' => 'أضف أفكارك هنا...',
			'home.noNotes' => 'لا توجد ملاحظات بعد.',
			'home.notesSaved' => 'تم حفظ الملاحظات والتقييم.',
			'home.save' => 'حفظ',
			'home.delete' => 'حذف',
			'home.addManualItem' => 'اضف يدوياً',
			'home.basicInformation' => 'معلومات اساسية',
			'home.media' => 'وسائط',
			'home.additionalDetails' => 'معلومات إضافية',
			'home.titleRequired' => 'العنوان مطلوب',
			'home.titleHint' => 'العنوان',
			'home.descriptionOptional' => 'الوصف (اختياري)',
			'home.imageUrlOptional' => 'البوستر (اختياري)',
			'home.additionalImagesOptional' => 'صور إضافية (روابط مفصولة بفاصلة)',
			'home.releaseDateOptional' => 'تاريخ الإصدار (اختياري)',
			'home.selectList' => 'أضف إلى قائمة',
			'home.pickImage' => 'اختر صورة',
			'home.removeImage' => 'إزالة الصورة',
			'home.genresOptional' => 'التصنيفات (مفصولة بفاصلة)',
			'home.publisherOptional' => 'الناشر / الاستوديو (اختياري)',
			'home.platformsOptional' => 'المنصات (مفصولة بفاصلة)',
			'sort.sort' => 'رتب',
			'sort.sortBy' => 'ترتيب حسب',
			'sort.title' => 'العنوان',
			'sort.releaseDate' => 'تاريخ الإصدار',
			'sort.rating' => 'التقييم',
			'sort.dateAdded' => 'تاريخ الإضافة',
			'search.search' => 'بحث',
			'search.searchPlaceholder' => 'ابحث...',
			'search.searchOrAdd' => 'ابحث عن أي شيء\n\nأو',
			'search.noResultsFound' => 'لم يتم العثور على نتائج. يمكنك إضافته يدوياً.',
			'search.cantSearch' => 'لا يمكن البحث الآن',
			'details.title' => 'تفاصيل',
			'details.movies' => 'الأفلام',
			'details.series' => 'المسلسلات',
			'details.games' => 'الألعاب',
			'details.books' => 'الكتب',
			'details.anime' => 'الأنمي',
			'details.manga' => 'المانجا',
			'details.description' => 'الوصف',
			'details.genres' => 'التصنيف',
			'details.progressTracker' => 'تتبع التقدم',
			'details.season' => 'الموسم',
			'details.episode' => 'الحلقة',
			'details.chapter' => 'الفصل',
			'details.volume' => 'المجلد',
			'details.releaseDate' => 'تاريخ الإصدار',
			'details.platforms' => 'المنصات',
			'details.rating' => 'التقييم',
			'details.publisher' => 'الناشر',
			'details.studio' => 'الشركة',
			'details.network' => 'الشبكة',
			'details.moreLikeThis' => 'مثل هذا',
			'details.noRecommendations' => 'لا توجد اقتراحات',
			'settings.backupAndRestore' => 'النسخ والاستعادة',
			'settings.settings' => 'الإعدادات',
			'settings.language' => 'اللغة',
			'settings.theme' => 'السمة',
			'settings.font' => 'الخط',
			'settings.appDefaultFont' => 'الخط الافتراضي',
			'settings.systemFont' => 'خط النظام',
			'settings.customFont' => 'خط مخصص',
			'settings.customFontDetails' => 'تفاصيل الخط المخصص',
			'settings.history' => 'السجل',
			'settings.apiChange' => 'تغيير الـAPI',
			'settings.statistics' => 'الإحصائيات',
			'settings.about' => 'حول التطبيق',
			'settings.monthRolloverBehavior' => 'سلوك ترحيل الشهر',
			'settings.monthRolloverBehaviorDescription' => 'اختر ما يحدث في بداية شهر جديد.',
			'settings.rolloverFull' => 'ترحيل كامل (افتراضي)',
			'settings.rolloverFullDescription' => 'نقل العناصر المكتملة إلى السجل والسؤال عن العناصر التي يجب الاحتفاظ بها في قائمة المهام.',
			'settings.rolloverPartial' => 'ترحيل جزئي',
			'settings.rolloverPartialDescription' => 'نقل العناصر المكتملة فقط إلى السجل. الاحتفاظ بجميع عناصر قائمة المهام.',
			'settings.rolloverManual' => 'يدوي',
			'settings.rolloverManualDescription' => 'لا تفعل شيئًا. سأدير قوائمي بنفسي.',
			'settings.showSeriesTracker' => 'إظهار متتبع المسلسلات',
			'settings.showSeriesTrackerDescription' => 'عرض الموسم والحلقة الحالية للمسلسلات التلفزيونية في القوائم الرئيسية.',
			'settings.showFilterToggle' => 'فلتر قابل للطي',
			'settings.showFilterToggleDescription' => 'إضافة زر في الشريط العلوي لإخفاء/إظهار الفلتر.',
			'languageSettings.selectLanguage' => 'اختر اللغة',
			'languageSettings.en' => 'English',
			'languageSettings.ar' => 'العربية',
			'themeSettings.themeSettings' => 'إعدادات السمة',
			'themeSettings.autoTheme' => 'السمة التلقائية',
			'themeSettings.manualTheme' => 'السمة اليدوية',
			'themeSettings.autoThemeDescription' => 'تتغير السمة تلقائياً بناءً على الشهر الحالي',
			'themeSettings.selectTheme' => 'اختر السمة:',
			'fontSettings.title' => 'إعدادات الخط',
			'fontSettings.change' => 'تغيير',
			'fontSettings.remove' => 'إزالة',
			'fontSettings.noCustomFont' => 'لم يتم تحديد خط مخصص',
			'fontSettings.selectFontFile' => 'اختر ملف الخط (.ttf, .otf)\'',
			'backupAndRestore.title' => 'النسخ الإحتياطي والاستعادة',
			'backupAndRestore.backupData' => 'النسخ الإحتياطي للبيانات',
			'backupAndRestore.restoreData' => 'إستعادة البيانات',
			'backupAndRestore.backupDescription' => 'حفظ القوائم الحالية في ملف.',
			'backupAndRestore.restoreDescription' => ' استعادة القوائم من الملف المحفوظ.',
			'backupAndRestore.backupSuccessful' => 'تم النسخ الإحتياطي بنجاح!',
			'backupAndRestore.backupFailed' => 'فشل النسخ الإحتياطي: ',
			'backupAndRestore.restoreSuccessful' => 'تم استعادة البيانات بنجاح!',
			'backupAndRestore.restoreFailed' => 'فشل استعادة البيانات: ',
			'backupAndRestore.noFileSelected' => 'لم يتم اختيار ملف.',
			'backupAndRestore.invalidFileFormat' => 'الملف غير صحيح او لا يوجد بيانات.',
			'backupAndRestore.selectBackupFile' => 'اختر ملف النسخ الإحتياطي',
			'backupAndRestore.saveBackupFile' => 'حفظ ملف النسخ الإحتياطي',
			'backupAndRestore.defaultBackupFileName' => 'noted_backup.json',
			'backupAndRestore.yes' => 'نعم',
			'backupAndRestore.no' => 'لا',
			'backupAndRestore.dataRestoredMessage' => 'تم استعادة البيانات بنجاح.',
			'history.history' => 'السجل',
			'history.item' => 'عنصر',
			'history.items' => 'عناصر',
			'history.noHistory' => 'لا يوجد سجل حتى الان',
			'apiSettings.gamesApiTitle' => 'الـAPI الخاص بالإلعاب',
			'apiSettings.gamesApiDescription' => 'احصل على الـAPI الخاص بك من RAWG.io',
			'apiSettings.moviesApiTitle' => 'الـAPI الخاص بالأفلام والمسلسلات',
			'apiSettings.moviesApiDescription' => 'احصل على الـAPI الخاص بك من The Movie Database',
			'apiSettings.booksApiTitle' => 'الـAPI الخاص بالكتب',
			'apiSettings.booksApiDescription' => 'احصل على الـAPI الخاص بك من Google Cloud Console',
			'apiSettings.getApiKey' => 'احصل على الـ API',
			'apiSettings.apiKey' => 'مفتاح API',
			'apiSettings.save' => 'حفظ',
			'apiSettings.delete' => 'حذف',
			'statistics.thisMonth' => 'هذا الشهر',
			'statistics.allTime' => 'كل الأوقات',
			'statistics.totalItems' => 'إجمالي العناصر',
			'statistics.category' => 'الفئات',
			'statistics.noData' => 'لا يوجد بيانات حتى الان',
			'about.aboutThisApp' => 'حول هذا التطبيق',
			'about.appDescription' => 'هذا التطبيق اٌنشئ بغرض التدريب فإذا واجهت مشكلة، ابلغ المطور على Github.',
			'about.reportIssue' => 'مشكلة؟',
			'about.viewProject' => 'صفحة التطبيق',
			'about.apisUsed' => 'الـAPIs المستخدمة',
			'about.gamesDescription' => 'بيانات الألعاب جاءت من موقع RAWG',
			'about.moviesAndTvSeries' => 'الأفلام والمسلسلات التلفزيونية',
			'about.moviesAndTvSeriesDescription' => 'جميع البيانات حول الأفلام والمسلسلات التلفزيونية جاءت من موقع TMDB',
			'about.booksDescription' => 'جميع البيانات حول الكتب جاءت من موقع Google Books API',
			'about.animeAndManga' => 'الأنمي والمانجا',
			'about.animeAndMangaDescription' => 'بيانات الأنمي والمانجا جاءت من Jikan, لا حاجة لـAPI',
			'about.thanksMessage' => 'بفضل خطتهم المجانية، أصبح التطبيق قابلًا للاستخدام كما هو الآن.',
			_ => null,
		};
	}
}
