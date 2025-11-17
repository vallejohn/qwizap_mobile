import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qwizap_mobile/core/services/admob_service.dart';
import '../../../../core/di/setup_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../core/params/categories_params.dart';
import '../bloc/categories_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with WidgetsBindingObserver, RouteAware {

  BannerAd? _bannerAd;
  late final _routeObserver = AppRouter().routeObserver;
  CategoriesBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Only create banner ad if it hasn't been shown this session
    _bannerAd = AdMobService.instance.createCategoriesBannerAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      _routeObserver.subscribe(this, route);
    }
  }

  void _loadScores() {
    if (mounted && _bloc != null) {
      _bloc!.add(const CategoriesEvent.loadScores());
    }
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and this route shows up
    _loadScores();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Reload scores when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _loadScores();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _routeObserver.unsubscribe(this);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        _bloc = sl<CategoriesBloc>()..add(const CategoriesEvent.fetch(CategoriesFetchParams(id: '')));
        return _bloc!;
      },
      child: Scaffold(
        body: SafeArea(
            child: BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, state) {
                  List<Widget> children = state.data.map<Widget>((category) {
                  final categoryKey = category.name.toLowerCase();
                  final score = state.categoryScores[categoryKey] ?? 0;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: FilledButton(
                        style: Theme.of(context).filledButtonTheme.style?.copyWith(
                            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 40, horizontal: 20)),
                            backgroundColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.09))
                        ),
                        onPressed: () {
                          context.pushNamed('quiz_proper', pathParameters: {'category': category.name});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                category.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (score > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  score.toString(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        )),
                  );
                }).toList();

                // Only insert banner ad if it exists (shown once per session)
                if (_bannerAd != null) {
                  final randomIndex = Random().nextInt(children.length + 1);
                  children.insert(randomIndex, AdMobService.instance.bannerAdWidget(_bannerAd!, key: const ValueKey('banner_ad')));
                }

                return ListView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: children,
                );
              },
            )),
      ),
    );
  }
}

