import 'dart:convert';
import 'package:AlethaWorkouts/models/exercise.model.dart';
import 'package:AlethaWorkouts/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  static const String baseUrl = AppConstants.baseUrl;
  static const String workoutsEndpoint =AppConstants.workoutsEndpoint;

  Future<List<Exercise>> fetchExercises() async {
    final uri = Uri.parse('$baseUrl$workoutsEndpoint');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Exercise.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
