import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_category.dart';
import '../../core/params/categories_params.dart';
import '../../data/models/categories_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/categories_usecase.dart';

part 'categories_event.dart';
part 'categories_state.dart';
part 'categories_bloc.freezed.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final _fetchUseCase = GetIt.instance<CategoriesFetchUseCase>();
  final _createUseCase = GetIt.instance<CategoriesCreateUseCase>();
  final _updateUseCase = GetIt.instance<CategoriesUpdateUseCase>();
  final _deleteUseCase = GetIt.instance<CategoriesDeleteUseCase>();

  CategoriesBloc() : super(const CategoriesState()) {
    on<_Fetch>(_onFetch);
    on<_Create>(_onCreate);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
  }

  Future<void> _onFetch(_Fetch event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(fetchStatus: CategoriesFetchStatus.loading));
    final result = await _fetchUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          fetchStatus: CategoriesFetchStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(
        state.copyWith(
          fetchStatus: CategoriesFetchStatus.success,
          data: data.data?? [],
        ),
      ),
    );
  }

  Future<void> _onCreate(_Create event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(createStatus: CategoriesCreateStatus.loading));
    final result = await _createUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          createStatus: CategoriesCreateStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(createStatus: CategoriesCreateStatus.success)),
    );
  }

  Future<void> _onUpdate(_Update event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(updateStatus: CategoriesUpdateStatus.loading));
    final result = await _updateUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          updateStatus: CategoriesUpdateStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(updateStatus: CategoriesUpdateStatus.success)),
    );
  }

  Future<void> _onDelete(_Delete event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(deleteStatus: CategoriesDeleteStatus.loading));
    final result = await _deleteUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          deleteStatus: CategoriesDeleteStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(deleteStatus: CategoriesDeleteStatus.success)),
    );
  }
}

