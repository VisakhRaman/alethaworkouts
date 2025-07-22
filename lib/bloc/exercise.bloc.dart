import 'package:AlethaWorkouts/bloc/exercise_list_event.bloc.dart';
import 'package:AlethaWorkouts/bloc/exercise_list_state.bloc.dart';
import 'package:AlethaWorkouts/repository/exercise.repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseListBloc extends Bloc<ExerciseListEvent, ExerciseListState> {
  final ExerciseRepository exerciseRepository;

  ExerciseListBloc({required this.exerciseRepository}) : super(ExerciseListInitial()) {
    on<FetchExercises>(_onFetchExercises);
    on<UpdateExerciseCompletion>(_onUpdateExerciseCompletion);
  }

  Future<void> _onFetchExercises(
    FetchExercises event,
    Emitter<ExerciseListState> emit,
  ) async {
    emit(ExerciseListLoading());
    try {
      final exercises = await exerciseRepository.getExercises();
      final lastContinuousDay = exerciseRepository.getLastContinuousDay();
      emit(ExerciseListLoaded(exercises, lastContinuousDay: lastContinuousDay));
    } catch (e) {
      emit(ExerciseListError(e.toString()));
    }
  }

   Future<void> _onUpdateExerciseCompletion(
    UpdateExerciseCompletion event,
    Emitter<ExerciseListState> emit,
  ) async {
    if (state is ExerciseListLoaded) {
      final currentState = state as ExerciseListLoaded;
      final updatedExercises = currentState.exercises.map((exercise) {
        return exercise.id == event.exerciseId
            ? exercise.copyWith(isCompleted: true)
            : exercise;
      }).toList();

      await exerciseRepository.markExerciseCompletedLocally(event.exerciseId);
      await exerciseRepository.recordExerciseDay(); // Record the day

      final lastContinuousDay = exerciseRepository.getLastContinuousDay(); // Get updated day
      emit(ExerciseListLoaded(updatedExercises, lastContinuousDay: lastContinuousDay));
    }
  }
}