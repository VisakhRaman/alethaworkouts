import 'package:AlethaWorkouts/models/exercise.model.dart';
import 'package:AlethaWorkouts/screens/exercise_detail.screen.dart';
import 'package:AlethaWorkouts/screens/exercise_list.screen.dart.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String exerciseListRoute = '/';
  static const String exerciseDetailRoute = '/exercise_detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case exerciseListRoute:
        return MaterialPageRoute(builder: (_) => const ExerciseListScreen());
      case exerciseDetailRoute:
        final exercise = settings.arguments as Exercise;
        return MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(exercise: exercise));
      default:
        return MaterialPageRoute(builder: (_) => const Text('Error: Unknown route'));
    }
  }
}