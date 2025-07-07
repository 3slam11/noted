///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr implements Translations {
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
	@override late final _TranslationsSearchAr search = _TranslationsSearchAr._(_root);
	@override late final _TranslationsDetailsAr details = _TranslationsDetailsAr._(_root);
	@override late final _TranslationsSettingsAr settings = _TranslationsSettingsAr._(_root);
	@override late final _TranslationsQrSettingsAr qrSettings = _TranslationsQrSettingsAr._(_root);
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
	@override String get titleSection => 'قائمة الترفيه لشهر ';
	@override String get emptySection => 'القائمة فارغة';
	@override String get finishedList => 'القائمة المكتملة';
	@override String get movies => 'الأفلام';
	@override String get series => 'المسلسلات';
	@override String get games => 'الألعاب';
	@override String get books => 'الكتب';
	@override String get all => 'الكل';
	@override String get deleted => 'حذفت';
	@override String get undo => 'تراجع';
	@override String get newMonthStarted => 'بدأ شهر جديد! 🎉';
	@override String description({required Object month}) => 'مرحبا بـ ${month}!';
	@override String get description2 => 'تم نقل العناصر المكتملة للسجل. هذه هي العناصر المتبقية من الشهر الماضي:';
	@override String get pending => '📝 في الانتظار: ';
	@override String get completed => '🎯 المكتمل: ';
	@override String get selectAll => 'تحديد الكل';
	@override String get deselectAll => 'إلغاء تحديد الكل';
	@override String get deleteAll => 'حذف الكل';
	@override String get addAll => 'اضف الكل';
	@override String get keepSelected => 'الاحتفاظ بالمحدد';
	@override String get noCompleted => 'لا يوجد عناصر مكتملة حتى الآن';
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
	@override String get editNotes => 'تعديل/عرض الملاحظات';
	@override String get yourRating => 'تقييمك';
	@override String get yourNotes => 'ملاحظاتك';
	@override String get notesHint => 'أضف أفكارك هنا...';
	@override String get noNotes => 'لا توجد ملاحظات بعد.';
	@override String get notesSaved => 'تم حفظ الملاحظات والتقييم.';
	@override String get save => 'حفظ';
	@override String get delete => 'حذف';
}

// Path: search
class _TranslationsSearchAr implements TranslationsSearchEn {
	_TranslationsSearchAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get search => 'بحث';
	@override String get searchPlaceholder => 'ابحث...';
	@override String get searchForSomething => 'ابحث عن اي شيء';
	@override String get noResultsFound => 'لم يتم العثور على نتائج';
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
	@override String get description => 'الوصف';
	@override String get releaseDate => 'تاريخ الإصدار';
	@override String get platforms => 'المنصات';
	@override String get rating => 'التقييم';
	@override String get publisher => 'الناشر';
	@override String get studio => 'الشركة';
	@override String get network => 'الشبكة';
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
}

// Path: qrSettings
class _TranslationsQrSettingsAr implements TranslationsQrSettingsEn {
	_TranslationsQrSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مزامنة بالـQR';
	@override String get desktop => 'الخاصية غير متوفرة على الكمبيوتر';
	@override String get desktopDescription => 'قارئ الـQR متوفرة فقط على الهواتف.';
	@override String get subtitle => 'مزامنة بين الأجهزة عن طريق الـQR';
	@override String get description => 'يمكنك مزامنة بياناتك واعدادتك على جهاز اخر.';
	@override String get alert => 'المزامنة ستستبدل بياناتك الحالية بالجديدة.';
	@override String get scan => 'امسح';
	@override String get generate => 'انشئ';
	@override String get generating => 'جاري انشاء الـQR...';
	@override String get generated => 'تم انشاء الـQR';
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
	@override String get apisUsed => 'الـAPIs المستخدمة';
	@override String get gamesDescription => 'بيانات الألعاب جاءت من موقع RAWG';
	@override String get moviesAndTvSeries => 'الأفلام والمسلسلات التلفزيونية';
	@override String get moviesAndTvSeriesDescription => 'جميع البيانات حول الأفلام والمسلسلات التلفزيونية جاءت من موقع TMDB';
	@override String get booksDescription => 'جميع البيانات حول الكتب جاءت من موقع Google Books API';
	@override String get thanksMessage => 'بفضل خطتهم المجانية، أصبح التطبيق قابلًا للاستخدام كما هو الآن.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appName': return 'نوتد';
			case 'months.0': return 'يناير';
			case 'months.1': return 'فبراير';
			case 'months.2': return 'مارس';
			case 'months.3': return 'أبريل';
			case 'months.4': return 'مايو';
			case 'months.5': return 'يونيو';
			case 'months.6': return 'يوليو';
			case 'months.7': return 'اغسطس';
			case 'months.8': return 'سبتمبر';
			case 'months.9': return 'أكتوبر';
			case 'months.10': return 'نوفمبر';
			case 'months.11': return 'ديسمبر';
			case 'routes.noRouteFound': return 'المسار غير موجود';
			case 'errorHandler.defaultError': return 'حدث خطأ ما، حاول مرة أخرى لاحقاً';
			case 'errorHandler.success': return 'نجاح';
			case 'errorHandler.noContent': return 'لا يوجد محتوى';
			case 'errorHandler.badRequest': return 'طلب سيء';
			case 'errorHandler.unauthorized': return 'غير مصرح به';
			case 'errorHandler.forbidden': return 'ممنوع';
			case 'errorHandler.internalServerError': return 'خطأ في الخادم الداخلي';
			case 'errorHandler.notFound': return 'غير موجود';
			case 'errorHandler.timeOut': return 'انقضى الوقت';
			case 'errorHandler.cancel': return 'إلغاء';
			case 'errorHandler.cacheError': return 'خطأ في الكاش';
			case 'errorHandler.noInternetConnection': return 'لا يوجد اتصال بالإنترنت';
			case 'errorHandler.errorOccurred': return 'حدث خطأ';
			case 'errorHandler.connectionIssuesTitle': return 'مشاكل الاتصال';
			case 'errorHandler.connectionIssuesSubtitle': return 'قد تكون هناك عدة أسباب لهذه المشكلة:';
			case 'errorHandler.internetNotWorking': return 'ربما الإنترنت لا يعمل.';
			case 'errorHandler.apiCapacityHit': return 'قد تكون سعة واجهة برمجة التطبيقات الافتراضية قد وصلت إلى الحد الأقصى.';
			case 'errorHandler.customApiError': return 'قد تكون واجهة برمجة التطبيقات المخصصة الخاصة بك مكتوبة بشكل غير صحيح.';
			case 'errorHandler.siteDownError': return 'قد يكون الموقع معطلاً في الوقت الحالي، انتظر بضع دقائق وحاول لاحقًا.';
			case 'stateRenderer.content': return 'المحتوى';
			case 'stateRenderer.error': return 'خطأ';
			case 'stateRenderer.loading': return 'تحميل';
			case 'stateRenderer.retry': return 'إعادة المحاولة';
			case 'stateRenderer.ok': return 'موافق';
			case 'home.titleSection': return 'قائمة الترفيه لشهر ';
			case 'home.emptySection': return 'القائمة فارغة';
			case 'home.finishedList': return 'القائمة المكتملة';
			case 'home.movies': return 'الأفلام';
			case 'home.series': return 'المسلسلات';
			case 'home.games': return 'الألعاب';
			case 'home.books': return 'الكتب';
			case 'home.all': return 'الكل';
			case 'home.deleted': return 'حذفت';
			case 'home.undo': return 'تراجع';
			case 'home.newMonthStarted': return 'بدأ شهر جديد! 🎉';
			case 'home.description': return ({required Object month}) => 'مرحبا بـ ${month}!';
			case 'home.description2': return 'تم نقل العناصر المكتملة للسجل. هذه هي العناصر المتبقية من الشهر الماضي:';
			case 'home.pending': return '📝 في الانتظار: ';
			case 'home.completed': return '🎯 المكتمل: ';
			case 'home.selectAll': return 'تحديد الكل';
			case 'home.deselectAll': return 'إلغاء تحديد الكل';
			case 'home.deleteAll': return 'حذف الكل';
			case 'home.addAll': return 'اضف الكل';
			case 'home.keepSelected': return 'الاحتفاظ بالمحدد';
			case 'home.noCompleted': return 'لا يوجد عناصر مكتملة حتى الآن';
			case 'home.congratulations': return 'تهانينا!';
			case 'home.todosDone': return 'لقد اكملت كل عناصر الشهر الماضي!';
			case 'home.close': return 'اغلاق';
			case 'home.timeWrong': return 'إما انك مسافر بالزمن أو قمت بتغيير التاريخ! 🕰️';
			case 'home.timeWrongDescription': return 'التطبيق لاحظ ان تاريخ هاتفك ربما لا يكون صحيحاً. هذا قد يعبث بالقوائم.';
			case 'home.continueAnyway': return 'استمر';
			case 'home.itemActions': return 'اختيارات العنصر';
			case 'home.moveToTodo': return 'نقل لقائمة المهام';
			case 'home.moveToFinished': return 'نقل للقائمة المكتملة';
			case 'home.moveToHistory': return 'نقل للسجل';
			case 'home.editNotes': return 'تعديل/عرض الملاحظات';
			case 'home.yourRating': return 'تقييمك';
			case 'home.yourNotes': return 'ملاحظاتك';
			case 'home.notesHint': return 'أضف أفكارك هنا...';
			case 'home.noNotes': return 'لا توجد ملاحظات بعد.';
			case 'home.notesSaved': return 'تم حفظ الملاحظات والتقييم.';
			case 'home.save': return 'حفظ';
			case 'home.delete': return 'حذف';
			case 'search.search': return 'بحث';
			case 'search.searchPlaceholder': return 'ابحث...';
			case 'search.searchForSomething': return 'ابحث عن اي شيء';
			case 'search.noResultsFound': return 'لم يتم العثور على نتائج';
			case 'search.cantSearch': return 'لا يمكن البحث الآن';
			case 'details.title': return 'تفاصيل';
			case 'details.movies': return 'الأفلام';
			case 'details.series': return 'المسلسلات';
			case 'details.games': return 'الألعاب';
			case 'details.books': return 'الكتب';
			case 'details.description': return 'الوصف';
			case 'details.releaseDate': return 'تاريخ الإصدار';
			case 'details.platforms': return 'المنصات';
			case 'details.rating': return 'التقييم';
			case 'details.publisher': return 'الناشر';
			case 'details.studio': return 'الشركة';
			case 'details.network': return 'الشبكة';
			case 'settings.backupAndRestore': return 'النسخ والاستعادة';
			case 'settings.settings': return 'الإعدادات';
			case 'settings.language': return 'اللغة';
			case 'settings.theme': return 'السمة';
			case 'settings.font': return 'الخط';
			case 'settings.appDefaultFont': return 'الخط الافتراضي';
			case 'settings.systemFont': return 'خط النظام';
			case 'settings.customFont': return 'خط مخصص';
			case 'settings.customFontDetails': return 'تفاصيل الخط المخصص';
			case 'settings.history': return 'السجل';
			case 'settings.apiChange': return 'تغيير الـAPI';
			case 'settings.statistics': return 'الإحصائيات';
			case 'settings.about': return 'حول التطبيق';
			case 'qrSettings.title': return 'مزامنة بالـQR';
			case 'qrSettings.desktop': return 'الخاصية غير متوفرة على الكمبيوتر';
			case 'qrSettings.desktopDescription': return 'قارئ الـQR متوفرة فقط على الهواتف.';
			case 'qrSettings.subtitle': return 'مزامنة بين الأجهزة عن طريق الـQR';
			case 'qrSettings.description': return 'يمكنك مزامنة بياناتك واعدادتك على جهاز اخر.';
			case 'qrSettings.alert': return 'المزامنة ستستبدل بياناتك الحالية بالجديدة.';
			case 'qrSettings.scan': return 'امسح';
			case 'qrSettings.generate': return 'انشئ';
			case 'qrSettings.generating': return 'جاري انشاء الـQR...';
			case 'qrSettings.generated': return 'تم انشاء الـQR';
			case 'languageSettings.selectLanguage': return 'اختر اللغة';
			case 'languageSettings.en': return 'English';
			case 'languageSettings.ar': return 'العربية';
			case 'themeSettings.themeSettings': return 'إعدادات السمة';
			case 'themeSettings.autoTheme': return 'السمة التلقائية';
			case 'themeSettings.manualTheme': return 'السمة اليدوية';
			case 'themeSettings.autoThemeDescription': return 'تتغير السمة تلقائياً بناءً على الشهر الحالي';
			case 'themeSettings.selectTheme': return 'اختر السمة:';
			case 'fontSettings.title': return 'إعدادات الخط';
			case 'fontSettings.change': return 'تغيير';
			case 'fontSettings.remove': return 'إزالة';
			case 'fontSettings.noCustomFont': return 'لم يتم تحديد خط مخصص';
			case 'fontSettings.selectFontFile': return 'اختر ملف الخط (.ttf, .otf)\'';
			case 'backupAndRestore.title': return 'النسخ الإحتياطي والاستعادة';
			case 'backupAndRestore.backupData': return 'النسخ الإحتياطي للبيانات';
			case 'backupAndRestore.restoreData': return 'إستعادة البيانات';
			case 'backupAndRestore.backupDescription': return 'حفظ القوائم الحالية في ملف.';
			case 'backupAndRestore.restoreDescription': return ' استعادة القوائم من الملف المحفوظ.';
			case 'backupAndRestore.backupSuccessful': return 'تم النسخ الإحتياطي بنجاح!';
			case 'backupAndRestore.backupFailed': return 'فشل النسخ الإحتياطي: ';
			case 'backupAndRestore.restoreSuccessful': return 'تم استعادة البيانات بنجاح!';
			case 'backupAndRestore.restoreFailed': return 'فشل استعادة البيانات: ';
			case 'backupAndRestore.noFileSelected': return 'لم يتم اختيار ملف.';
			case 'backupAndRestore.invalidFileFormat': return 'الملف غير صحيح او لا يوجد بيانات.';
			case 'backupAndRestore.selectBackupFile': return 'اختر ملف النسخ الإحتياطي';
			case 'backupAndRestore.saveBackupFile': return 'حفظ ملف النسخ الإحتياطي';
			case 'backupAndRestore.defaultBackupFileName': return 'noted_backup.json';
			case 'backupAndRestore.yes': return 'نعم';
			case 'backupAndRestore.no': return 'لا';
			case 'backupAndRestore.dataRestoredMessage': return 'تم استعادة البيانات بنجاح.';
			case 'history.history': return 'السجل';
			case 'history.item': return 'عنصر';
			case 'history.items': return 'عناصر';
			case 'history.noHistory': return 'لا يوجد سجل حتى الان';
			case 'apiSettings.gamesApiTitle': return 'الـAPI الخاص بالإلعاب';
			case 'apiSettings.gamesApiDescription': return 'احصل على الـAPI الخاص بك من RAWG.io';
			case 'apiSettings.moviesApiTitle': return 'الـAPI الخاص بالأفلام والمسلسلات';
			case 'apiSettings.moviesApiDescription': return 'احصل على الـAPI الخاص بك من The Movie Database';
			case 'apiSettings.booksApiTitle': return 'الـAPI الخاص بالكتب';
			case 'apiSettings.booksApiDescription': return 'احصل على الـAPI الخاص بك من Google Cloud Console';
			case 'apiSettings.getApiKey': return 'احصل على الـ API';
			case 'apiSettings.apiKey': return 'مفتاح API';
			case 'apiSettings.save': return 'حفظ';
			case 'apiSettings.delete': return 'حذف';
			case 'statistics.thisMonth': return 'هذا الشهر';
			case 'statistics.allTime': return 'كل الأوقات';
			case 'statistics.totalItems': return 'إجمالي العناصر';
			case 'statistics.category': return 'الفئات';
			case 'statistics.noData': return 'لا يوجد بيانات حتى الان';
			case 'about.aboutThisApp': return 'حول هذا التطبيق';
			case 'about.appDescription': return 'هذا التطبيق اٌنشئ بغرض التدريب فإذا واجهت مشكلة، ابلغ المطور على Github.';
			case 'about.apisUsed': return 'الـAPIs المستخدمة';
			case 'about.gamesDescription': return 'بيانات الألعاب جاءت من موقع RAWG';
			case 'about.moviesAndTvSeries': return 'الأفلام والمسلسلات التلفزيونية';
			case 'about.moviesAndTvSeriesDescription': return 'جميع البيانات حول الأفلام والمسلسلات التلفزيونية جاءت من موقع TMDB';
			case 'about.booksDescription': return 'جميع البيانات حول الكتب جاءت من موقع Google Books API';
			case 'about.thanksMessage': return 'بفضل خطتهم المجانية، أصبح التطبيق قابلًا للاستخدام كما هو الآن.';
			default: return null;
		}
	}
}

