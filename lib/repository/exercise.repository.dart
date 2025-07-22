import 'package:AlethaWorkouts/models/exercise.model.dart';
import 'package:AlethaWorkouts/services/api.service.dart';
import 'package:AlethaWorkouts/services/storage.service.dart';


class ExerciseRepository {
  final ExerciseApiService apiService;
  final LocalStorageService localStorageService;

  ExerciseRepository({
    required this.apiService,
    required this.localStorageService,
  });

  Future<List<Exercise>> getExercises() async {
    try {
      final List<Exercise> exercises = await apiService.fetchExercises();
      final List<String> completedIds = localStorageService.getCompletedExercises();

      // Mark exercises as completed based on local storage
      return exercises.map((exercise) {
        return exercise.copyWith(isCompleted: completedIds.contains(exercise.id));
      }).toList();
    } catch (e) {
      rethrow; // Rethrow the exception 
    }
  }

  Future<void> markExerciseCompletedLocally(String exerciseId) async {
    await localStorageService.markExerciseCompleted(exerciseId);
  }

  String? getLastContinuousDay() {
    return localStorageService.getLastRecordedDay();
  }

  Future<void> recordExerciseDay() async {
    await localStorageService.recordExerciseDay();
  }
}