import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';

bool isEmailValidFunc(String email) => RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
).hasMatch(email);

Future<bool> checkForNewMonth() async {
  final prefs = instance<AppPrefs>();
  final lastOpenedMonth = await prefs.getLastOpenedMonth();
  final currentMonth = DateTime.now().month;

  if (lastOpenedMonth == null) {
    await prefs.setLastOpenedMonth(currentMonth);
    return false;
  } else if (lastOpenedMonth != currentMonth) {
    await prefs.setLastOpenedMonth(currentMonth);
    return true;
  } else {
    return false;
  }
}
