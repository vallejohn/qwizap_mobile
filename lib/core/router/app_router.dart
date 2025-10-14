import 'package:go_router/go_router.dart';
import 'package:qwizap_mobile/features/categories/presentation/pages/categories_page.dart';
import 'package:qwizap_mobile/features/generate/presentation/pages/generate_page.dart';

import '../../src/qwizap/data/models/question_category.dart';
import '../../src/qwizap/presentation/pages/category_selection_page.dart';
import '../../src/qwizap/presentation/pages/quiz_page.dart';

class AppRouter {

  late GoRouter _router;

  GoRouter get router => _router;

  static final AppRouter _singleton = AppRouter._internal();

  factory AppRouter() {
    return _singleton;
  }

  AppRouter._internal();

  void init() {
    _router = _RouteConfiguration().configuredRouter;
  }
}

class _RouteConfiguration {
  GoRouter get configuredRouter => GoRouter(
      observers: [
      ],
      routes: [
        GoRoute(
          path: '/',
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