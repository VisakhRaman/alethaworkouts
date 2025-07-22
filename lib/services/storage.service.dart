import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _preferences;
    static const String completedExercisesKey = 'completed_exercises';
  static const String lastContinuousDayKey = 'last_continuous_day';

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Exercise Completion
  Future<void> markExerciseCompleted(String exerciseId) async {
    List<String> completedIds = getCompletedExercises();
    if (!completedIds.contains(exerciseId)) {
      completedIds.add(exerciseId);
      await _preferences.setStringList(completedExercisesKey, completedIds);
    }
  }

  List<String> getCompletedExercises() {
    return _preferences.getStringList(completedExercisesKey) ?? [];
  }

  Future<void> clearCompletedExercises() async {
    await _preferences.remove(completedExercisesKey);
  }

  // Continuous Days Tracker
  Future<void> recordExerciseDay() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? lastRecordedDay = _preferences.getString(lastContinuousDayKey);

    if (lastRecordedDay == null) {
      // First time recording
      await _preferences.setString(lastContinuousDayKey, today);
    } else {
      DateTime lastDay = DateTime.parse(lastRecordedDay);
      DateTime nextExpectedDay = lastDay.add(const Duration(days: 1));

      if (nextExpectedDay.day == DateTime.now().day &&
          nextExpectedDay.month == DateTime.now().month &&
          nextExpectedDay.year == DateTime.now().year) {
        // Continuous day
        await _preferences.setString(lastContinuousDayKey, today);
      } else if (lastRecordedDay != today) {
        // Not continuous, reset
        await _preferences.setString(lastContinuousDayKey, today);
      }
      // If lastRecordedDay == today, do nothing (already recorded for today)
    }
  }

  String? getLastRecordedDay() {
    return _preferences.getString(lastContinuousDayKey);
  }
}