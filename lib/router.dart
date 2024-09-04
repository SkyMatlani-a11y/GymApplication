import 'package:go_router/go_router.dart';
import 'package:gym_application/widgets/workout.dart';
import 'package:gym_application/widgets/workout_list.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: '/',
      path: '/',
      builder: (context, state) => const WorkOutList(),
    ),
    GoRoute(
        name: '/add_set',
        path: '/add_set',
        builder: (context, state) {
          Map<String, dynamic> params = state.extra as Map<String, dynamic>;
          return Workout(
            workoutSetList: params['workoutSetList']! as List<dynamic>,
            index: params['index'] != null ? params['index'] as int : null,
          );
        }),
  ],
);
