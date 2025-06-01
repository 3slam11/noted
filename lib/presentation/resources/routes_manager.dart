import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/about/view/about_view.dart';
import 'package:noted/presentation/backupAndRestore/view/backup_and_restore_view.dart';
import 'package:noted/presentation/changeApi/view/change_api_view.dart';
import 'package:noted/presentation/history/view/history_view.dart';
import 'package:noted/presentation/main/view/main_view.dart';
import 'package:noted/presentation/search/view/search_view.dart';
import 'package:noted/presentation/settings/view/settings_view.dart';
import 'package:noted/presentation/statistics/view/statistics_view.dart';
import 'package:noted/presentation/details/view/details_view.dart';

class RoutesManager {
  static const String mainRoute = '/';
  static const String detailsRoute = '/details';
  static const String searchRoute = '/search';
  static const String settingsRoute = '/settings';
  static const String backupAndRestoreRoute = '/backup-restore';
  static const String historyRoute = '/history';
  static const String changeApiRoute = '/change-api';
  static const String statisticsRoute = '/statistics';
  static const String aboutRoute = '/about';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesManager.mainRoute:
        initMainModule();
        return MaterialPageRoute(builder: (_) => MainView());
      case RoutesManager.searchRoute:
        initSearchModule();
        return MaterialPageRoute(builder: (_) => SearchView());
      case RoutesManager.detailsRoute:
        initDetailsModule();
        final args = settings.arguments;
        if (args is DetailsView) {
          return MaterialPageRoute(
            builder: (_) => DetailsView(id: args.id, category: args.category),
          );
        }
        return unDefinedRoute();
      case RoutesManager.settingsRoute:
        initSettingsModule();
        return MaterialPageRoute(builder: (_) => SettingsView());
      case RoutesManager.historyRoute:
        initHistoryModule();
        return MaterialPageRoute(builder: (_) => HistoryView());
      case RoutesManager.backupAndRestoreRoute:
        initBackupAndRestoreModule();
        return MaterialPageRoute(builder: (_) => BackupAndRestoreView());
      case RoutesManager.changeApiRoute:
        initChangeApiModule();
        return MaterialPageRoute(builder: (_) => ChangeApiView());
      case RoutesManager.statisticsRoute:
        initStatisticsModule();
        return MaterialPageRoute(builder: (_) => StatisticsView());
      case RoutesManager.aboutRoute:
        return MaterialPageRoute(builder: (_) => AboutView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text(t.routes.noRouteFound)),
        body: Center(child: Text(t.routes.noRouteFound)),
      ),
    );
  }
}
