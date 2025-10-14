import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qwizap_mobile/core/router/app_router.dart';
import 'package:qwizap_mobile/src/qwizap/presentation/blocs/category_selection/category_selection_bloc.dart';

class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({super.key});

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategorySelectionBloc>(context).add(
      const CategorySelectionEvent.onInitCategories(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CategorySelectionBloc, CategorySelectionState>(
          builder: (catContext, catState) {
            return ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: catState.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: FilledButton(
                    style: Theme.of(context).filledButtonTheme.style?.copyWith(
                      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 40)),
                      backgroundColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.09))
                    ),
                      onPressed: () {
                        catContext.read<CategorySelectionBloc>().add(
                              CategorySelectionEvent.onSelectCategory(category),
                            );
                        context.go('/quiz_proper', extra: category);
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
        ),
      ),
    );
  }
}
