import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final int duration; 
  final String difficulty;
  final bool isCompleted; 

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    this.isCompleted = false, // Default to false
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
      difficulty: json['difficulty'] as String,
      // isCompleted will be set locally, not from API
    );
  }

  // Helper to create a copy with updated completion status
  Exercise copyWith({
    bool? isCompleted,
  }) {
    return Exercise(
      id: id,
      name: name,
      description: description,
      duration: duration,
      difficulty: difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, name, description, duration, difficulty, isCompleted];
}