import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';
import 'package:noted/presentation/settings/view/settings_view.dart';

bool isEmailValidFunc(String email) => RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
).hasMatch(email);

Future<int> checkForNewMonth() async {
  final prefs = instance<AppPrefs>();

  // Check the user's selected behavior for month rollover
  final behaviorIndex = await prefs.getMonthRolloverBehavior();
  final behavior = MonthRolloverBehavior.values[behaviorIndex];

  // If behavior is manual, do nothing.
  if (behavior == MonthRolloverBehavior.manual) {
    return 1; // Return 1 to signify no action is needed
  }

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
