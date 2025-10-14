import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/use_case.dart';
import '../../core/params/categories_params.dart';
import '../repositories/categories_repository.dart';

class CategoriesFetchUseCase extends UseCaseWithParams<CategoriesOperationResult, CategoriesFetchParams>{
  final CategoriesRepository _repository;

  CategoriesFetchUseCase(this._repository);

  @override
  Future<Either<Failure, CategoriesOperationResult>> call(param) {
    return _repository.fetch(param);
  }
}

class CategoriesCreateUseCase extends UseCaseWithParams<bool, CategoriesCreateParams>{
  final CategoriesRepository _repository;

  CategoriesCreateUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CategoriesCreateParams param) {
    return _repository.create(param);
  }
}

class CategoriesUpdateUseCase extends UseCaseWithParams<bool, CategoriesUpdateParams>{
  final CategoriesRepository _repository;

  CategoriesUpdateUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CategoriesUpdateParams param) {
    return _repository.update(param);
  }
}

class CategoriesDeleteUseCase extends UseCaseWithParams<bool, CategoriesDeleteParams>{
  final CategoriesRepository _repository;

  CategoriesDeleteUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CategoriesDeleteParams param) {
    return _repository.delete(param);
  }
}  
