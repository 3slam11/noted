export 'qr_import_view_desktop.dart'
    if (dart.library.io) 'qr_import_view_mobile.dart'
    if (dart.library.html) 'qr_import_view_desktop.dart';
