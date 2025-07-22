import 'package:AlethaWorkouts/models/exercise.model.dart';
import 'package:equatable/equatable.dart';

abstract class ExerciseListState extends Equatable {
  const ExerciseListState();

  @override
  List<Object> get props => [];
}

class ExerciseListInitial extends ExerciseListState {}

class ExerciseListLoading extends ExerciseListState {}

class ExerciseListLoaded extends ExerciseListState {
  final List<Exercise> exercises;
  final String? lastContinuousDay; 

  const ExerciseListLoaded(this.exercises, {this.lastContinuousDay});

  @override
  List<Object> get props => [exercises, lastContinuousDay ?? ''];
}

class ExerciseListError extends ExerciseListState {
  final String message;

  const ExerciseListError(this.message);

  @override
  List<Object> get props => [message];
}