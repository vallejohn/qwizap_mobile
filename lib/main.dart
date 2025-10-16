import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:qwizap_mobile/core/di/setup_locator.dart';
import 'package:qwizap_mobile/question_proper.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';
import 'package:qwizap_mobile/src/qwizap/presentation/blocs/category_selection/category_selection_bloc.dart';
import 'package:qwizap_mobile/src/qwizap/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:qwizap_mobile/src/qwizap/presentation/blocs/timer/timer_bloc.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'app_bloc_observer.dart';
import 'core/router/app_router.dart';
import 'core/services/level_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  AppRouter().init();

  await dotenv.load(fileName: '.env');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await setupLocator();

  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff004148);
    const secondaryColor = Color(0xFFFF1900);

    final levelManager = LevelManager();
    levelManager.initLevel();

    return MultiBlocProvider(
      providers: [
        BlocProvider<QuizBloc>(
          create: (context) => QuizBloc(levelManager: levelManager),
        ),
        BlocProvider<TimerBloc>(
          create: (context) => TimerBloc(Ticker()),
        ),
        BlocProvider<CategorySelectionBloc>(
          create: (context) => CategorySelectionBloc(),
        )
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              secondary: secondaryColor,
            ),
            useMaterial3: true,
            fontFamily: 'Rubik'),
        darkTheme: ThemeData(
          filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(
                secondaryColor,
              ),
              shape: WidgetStatePropertyAll(
                SmoothRectangleBorder(
                  smoothness: 1,
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              )),
              textStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
          scaffoldBackgroundColor: primaryColor,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: primaryColor,
            secondary: secondaryColor,
          ),
          useMaterial3: true,
          fontFamily: 'Rubik',
        ),
        themeMode: ThemeMode.dark,
        routeInformationParser: AppRouter().router.routeInformationParser,
        routeInformationProvider: AppRouter().router.routeInformationProvider,
        routerDelegate: AppRouter().router.routerDelegate,
      ),
    );
  }
}