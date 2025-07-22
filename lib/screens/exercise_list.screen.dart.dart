import 'package:AlethaWorkouts/bloc/exercise.bloc.dart';
import 'package:AlethaWorkouts/bloc/exercise_list_event.bloc.dart';
import 'package:AlethaWorkouts/bloc/exercise_list_state.bloc.dart';
import 'package:AlethaWorkouts/utils/app_constants.dart';
import 'package:AlethaWorkouts/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch event to fetch exercises when the screen initializes
    context.read<ExerciseListBloc>().add(FetchExercises());
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '$minutes min';
      } else {
        return '$minutes min $remainingSeconds sec';
      }
    }
  }

  String _getContinuousDaysText(String? lastRecordedDay) {
    if (lastRecordedDay == null) {
      return 'No exercises recorded yet.';
    }

    DateTime lastDay = DateTime.parse(lastRecordedDay);
    DateTime now = DateTime.now();

    // Check if the last recorded day is today
    if (lastDay.day == now.day && lastDay.month == now.month && lastDay.year == now.year) {
      return 'You exercised today!';
    }

    // Check if the last recorded day was yesterday
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (lastDay.day == yesterday.day && lastDay.month == yesterday.month && lastDay.year == yesterday.year) {
      return 'You exercised yesterday! Keep it up.';
    }

    // Otherwise, not continuous
    return 'Last exercise: ${DateFormat('MMM dd, yyyy').format(lastDay)}. Streak broken.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aletha Workouts'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: BlocConsumer<ExerciseListBloc, ExerciseListState>(
          listener: (context, state) {
            if (state is ExerciseListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ExerciseListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExerciseListLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Optional: Progress Tracker
                  Card(
                    elevation: AppConstants.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                          const SizedBox(width: AppConstants.defaultPadding),
                          Expanded(
                            child: Text(
                              _getContinuousDaysText(state.lastContinuousDay),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: state.exercises.isEmpty
                        ? const Center(child: Text('No exercises available.'))
                        : ListView.builder(
                            itemCount: state.exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = state.exercises[index];
                              return Card(
                                elevation: AppConstants.cardElevation,
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.exerciseDetailRoute,
                                      arguments: exercise,
                                    ).then((_) {
                                      // When returning from detail screen, refresh list
                                      context.read<ExerciseListBloc>().add(FetchExercises());
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                exercise.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Duration: ${_formatDuration(exercise.duration)}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (exercise.isCompleted)
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 30,
                                          )
                                        else
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            } else if (state is ExerciseListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'Failed to load exercises: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ExerciseListBloc>().add(FetchExercises());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
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
                ),
              );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await context.read<ExerciseListBloc>().exerciseRepository.localStorageService.clearCompletedExercises();
          context.read<ExerciseListBloc>().add(FetchExercises()); // Refetch to update UI
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Completed exercises cleared.')),
          );
        },
       
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.refresh, color: Colors.white), // Using refresh for simplicity
      ),
    );
  }
}