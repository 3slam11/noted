import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/about/view/about_view.dart';
import 'package:noted/presentation/backupAndRestore/view/backup_and_restore_view.dart';
import 'package:noted/presentation/changeApi/view/change_api_view.dart';
import 'package:noted/presentation/details/view/details_view.dart';
import 'package:noted/presentation/home/home_view.dart';
import 'package:noted/presentation/statistics/view/statistics_view.dart';

class RoutesManager {
  static const String mainRoute = '/';
  static const String detailsRoute = '/details';
  static const String backupAndRestoreRoute = '/backup-restore';
  static const String changeApiRoute = '/change-api';
  static const String statisticsRoute = '/statistics';
  static const String aboutRoute = '/about';
  static const String historyRoute = '/history';
  static const String settingsRoute = '/settings';
  static const String searchRoute = '/search';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesManager.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const HomeView());
      case RoutesManager.detailsRoute:
        initDetailsModule();
        final args = settings.arguments;
        if (args is DetailsView) {
          return MaterialPageRoute(
            builder: (_) => DetailsView(id: args.id, category: args.category),
          );
        }
        return unDefinedRoute();
      case RoutesManager.backupAndRestoreRoute:
        initBackupAndRestoreModule();
        return MaterialPageRoute(builder: (_) => const BackupAndRestoreView());
      case RoutesManager.changeApiRoute:
        initChangeApiModule();
        return MaterialPageRoute(builder: (_) => const ChangeApiView());
      case RoutesManager.statisticsRoute:
        initStatisticsModule();
        return MaterialPageRoute(builder: (_) => const StatisticsView());
      case RoutesManager.aboutRoute:
        return MaterialPageRoute(builder: (_) => const AboutView());
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
