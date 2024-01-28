import 'package:go_router/go_router.dart';
import 'package:stop_watch/presentation/screens/stop_watch_screen.dart';

final appRouter = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const StopWatchScreen()),
]);
