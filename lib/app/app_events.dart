import 'package:flutter/foundation.dart';

class DataGlobalNotifier extends ChangeNotifier {
  void notifyDataImported() {
    notifyListeners();
  }
}
