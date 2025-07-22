import 'package:AlethaWorkouts/bloc/exercise.bloc.dart';
import 'package:AlethaWorkouts/repository/exercise.repository.dart';
import 'package:AlethaWorkouts/services/api.service.dart';
import 'package:AlethaWorkouts/services/storage.service.dart';
import 'package:AlethaWorkouts/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utils/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init(); // Initialize shared_preferences

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ExerciseApiService apiService = ExerciseApiService();
    final LocalStorageService localStorageService = LocalStorageService();
    final ExerciseRepository exerciseRepository = ExerciseRepository(
      apiService: apiService,
      localStorageService: localStorageService,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<ExerciseListBloc>(
          create: (context) => ExerciseListBloc(
            exerciseRepository: exerciseRepository,
          ),
        ),
        // ExerciseDetailBloc is created on demand in ExerciseDetailScreen
        // as it's specific to that screen's state (timer).
      ],
      child: MaterialApp(
        title: 'Exercise App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey, // A neutral, clean color
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              elevation: AppConstants.cardElevation,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.exerciseListRoute,
      ),
    );
  }
}