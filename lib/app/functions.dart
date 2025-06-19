import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';

bool isEmailValidFunc(String email) => RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
).hasMatch(email);

Future<int> checkForNewMonth() async {
  final prefs = instance<AppPrefs>();
  final lastOpenedMonth = await prefs.getLastOpenedMonth();
  final currentMonth = DateTime.now().year * 12 + DateTime.now().month;

  if (lastOpenedMonth == null) {
    await prefs.setLastOpenedMonth(currentMonth);
    return 1;
  } else if (lastOpenedMonth > currentMonth) {
    await prefs.setLastOpenedMonth(currentMonth);
    return 2;
  } else if (lastOpenedMonth != currentMonth) {
    await prefs.setLastOpenedMonth(currentMonth);
    return 3;
  } else {
    return 1;
  }
}
