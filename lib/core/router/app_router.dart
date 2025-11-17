import 'package:go_router/go_router.dart';
import 'package:qwizap_mobile/features/categories/presentation/pages/categories_page.dart';
import 'package:qwizap_mobile/features/generate/presentation/pages/generate_page.dart';

import 'route_observer.dart';

class AppRouter {

  late GoRouter _router;
  final _routeObserver = AppRouteObserver();

  GoRouter get router => _router;
  AppRouteObserver get routeObserver => _routeObserver;

  static final AppRouter _singleton = AppRouter._internal();

  factory AppRouter() {
    return _singleton;
  }

  AppRouter._internal();

  void init() {
    _router = _RouteConfiguration(_routeObserver).configuredRouter;
  }
}

class _RouteConfiguration {
  final AppRouteObserver routeObserver;

  _RouteConfiguration(this.routeObserver);

  GoRouter get configuredRouter => GoRouter(
      observers: [
        routeObserver,
      ],
      routes: [
        GoRoute(
          path: '/',
          name: '/',
          builder: (context, state) => const CategoriesPage(),
          routes: [
            GoRoute(
              name: 'quiz_proper',
                path: 'quiz_proper/:category',
                builder: (context, state){
                final category = state.pathParameters['category']!;
                return GeneratePage(category: category,);
                }
            ),
          ]
        ),
      ]
  );
}