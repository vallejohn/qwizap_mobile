import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/use_case.dart';
import '../../core/params/generate_params.dart';
import '../repositories/generate_repository.dart';

class GenerateFetchUseCase extends UseCaseWithParams<GenerateOperationResult, GenerateFetchParams>{
  final GenerateRepository _repository;

  GenerateFetchUseCase(this._repository);

  @override
  Future<Either<Failure, GenerateOperationResult>> call(param) {
    return _repository.fetch(param);
  }
}

class GenerateCreateUseCase extends UseCaseWithParams<bool, GenerateCreateParams>{
  final GenerateRepository _repository;

  GenerateCreateUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(GenerateCreateParams param) {
    return _repository.create(param);
  }
}

class GenerateUpdateUseCase extends UseCaseWithParams<bool, GenerateUpdateParams>{
  final GenerateRepository _repository;

  GenerateUpdateUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(GenerateUpdateParams param) {
    return _repository.update(param);
  }
}

class GenerateDeleteUseCase extends UseCaseWithParams<bool, GenerateDeleteParams>{
  final GenerateRepository _repository;

  GenerateDeleteUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(GenerateDeleteParams param) {
    return _repository.delete(param);
  }
}  
