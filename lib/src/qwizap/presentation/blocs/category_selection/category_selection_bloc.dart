import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;  // For asset loading

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_category.dart';

part 'category_selection_event.dart';
part 'category_selection_state.dart';
part 'category_selection_bloc.freezed.dart';

class CategorySelectionBloc
    extends Bloc<CategorySelectionEvent, CategorySelectionState> {

  final _log = Logger();

  CategorySelectionBloc() : super(const CategorySelectionState()) {
    on<_OnInitCategories>(_onInitCategories);
    on<_OnSelectCategory>(_onSelectCategory);
  }

  FutureOr<void> _onInitCategories(
    _OnInitCategories event,
    Emitter<CategorySelectionState> emit,
  ) async {
    emit(state.copyWith(status: CategorySelectionStatus.loading));

    try {
      String content = await rootBundle.loadString('assets/data.json');
      final data = jsonDecode(content);


      _log.i('hete');
      _log.i(data);

      final list = (data['categories'] as List)
          .map((e) => QuestionCategory.fromJson(e))
          .toList();
      emit(state.copyWith(
        categories: list,
        status: CategorySelectionStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategorySelectionStatus.failed,
        message: e.toString()
      ));
    }
  }

  FutureOr<void> _onSelectCategory(
    _OnSelectCategory event,
    Emitter<CategorySelectionState> emit,
  ) {
    emit(state.copyWith(
      selectedCategory: event.category
    ));
  }
}
