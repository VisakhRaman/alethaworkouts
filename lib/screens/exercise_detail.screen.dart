import 'package:AlethaWorkouts/bloc/exercise.bloc.dart';
import 'package:AlethaWorkouts/bloc/exercise_detail_bloc.dart';
import 'package:AlethaWorkouts/bloc/exercise_detail_event.dart';
import 'package:AlethaWorkouts/bloc/exercise_detail_state.bloc.dart';
import 'package:AlethaWorkouts/bloc/exercise_list_event.bloc.dart';
import 'package:AlethaWorkouts/models/exercise.model.dart';
import 'package:AlethaWorkouts/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';


class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '$minutes minutes';
      } else {
        return '$minutes minutes and $remainingSeconds seconds';
      }
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use BlocProvider.value here to use the existing bloc from the main app
    return BlocProvider<ExerciseDetailBloc>(
      create: (context) => ExerciseDetailBloc(), // Create a new bloc for this screen
      child: Scaffold(
        appBar: AppBar(
          title: Text(exercise.name),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                exercise.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Row(
                children: [
                  const Icon(Icons.timer),
                  const SizedBox(width: 8),
                  Text(
                    'Duration: ${_formatDuration(exercise.duration)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.fitness_center),
                  const SizedBox(width: 8),
                  Text(
                    'Difficulty: ${exercise.difficulty}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getDifficultyColor(exercise.difficulty),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.largePadding * 2),
              Center(
                child: BlocConsumer<ExerciseDetailBloc, ExerciseDetailState>(
                  listener: (context, state) {
                    if (state is ExerciseTimerCompleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Exercise Completed!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      // Mark exercise as completed in the list
                      context.read<ExerciseListBloc>().add(UpdateExerciseCompletion(state.exerciseId));
                      // Navigate back to home screen after a short delay
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is ExerciseDetailInitial) {
                      return ElevatedButton.icon(
                        onPressed: () {
                          if (exercise.isCompleted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('This exercise is already completed!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                          context.read<ExerciseDetailBloc>().add(
                                StartExerciseTimer(exercise.duration, exercise.id),
                              );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          exercise.isCompleted ? 'COMPLETED' : 'START EXERCISE',
                          style: const TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: exercise.isCompleted ? Colors.grey : Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          ),
                          elevation: AppConstants.cardElevation,
                        ),
                      );
                    } else if (state is ExerciseTimerRunning) {
                      return Column(
                        children: [
                          Text(
                            'Time Remaining:',
                            style: TextStyle(fontSize: 22, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 10),
                        
                          CircularCountDownTimer(
                            duration: state.remainingSeconds, 
                            initialDuration: 0, 
                            controller: CountDownController(), 
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 2.5,
                            ringColor: Colors.grey[300]!,
                            ringGradient: null,
                            fillColor: Theme.of(context).primaryColor,
                            fillGradient: null,
                            backgroundColor: Colors.transparent,
                            backgroundGradient: null,
                            strokeWidth: 20.0,
                            strokeCap: StrokeCap.round,
                            textStyle: const TextStyle(
                              fontSize: 60.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textFormat: CountdownTextFormat.S, 
                            autoStart: true,
                            isReverse: true, 
                            onStart: () {
                              debugPrint('Countdown Started');
                            },
                            onComplete: () {
                              debugPrint('Countdown Completed');
                            },
                            onChange: (String timeStamp) {
                              debugPrint('Countdown Changed $timeStamp');
                            },
                          ),
                          const SizedBox(height: AppConstants.defaultPadding),
                          Text(
                            'Keep Going!',
                            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.blueGrey[400]),
                          ),
                        ],
                      );
                    } else if (state is ExerciseTimerCompleted) {
                      return Column(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                          const SizedBox(height: 10),
                          const Text(
                            'Exercise Finished!',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<ExerciseDetailBloc>().add(ResetExerciseDetail());
                              Navigator.pop(context); 
                            },
                            icon: const Icon(Icons.home),
                            label: const Text('Back to Home', style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}