import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/setup_locator.dart';
import '../../core/params/categories_params.dart';
import '../bloc/categories_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoriesBloc>()..add(const CategoriesEvent.fetch(CategoriesFetchParams(id: ''))),
      child: Scaffold(
        body: SafeArea(
            child: BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                return ListView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: state.data.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: FilledButton(
                          style: Theme.of(context).filledButtonTheme.style?.copyWith(
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 40)),
                              backgroundColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.09))
                          ),
                          onPressed: () {
                            context.go('/quiz_proper/${category.name}');
                          },
                          child: Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                    );
                  }).toList(),
                );
              },
            )),
      ),
    );
  }
}

