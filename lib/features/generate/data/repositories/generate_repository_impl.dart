import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../core/params/generate_params.dart';
import '../../domain/repositories/generate_repository.dart';
import '../datasources/generate_remote_data_source.dart';

class GenerateRepositoryImpl implements GenerateRepository {
  final GenerateRemoteDataSource dataSource;

  GenerateRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, GenerateOperationResult>> fetch(GenerateFetchParams param) async {
    try {
      final data = await dataSource.fetch(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> create(GenerateCreateParams param) async {
    try {
      final data = await dataSource.create(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> update(GenerateUpdateParams param) async {
    try {
      final data = await dataSource.update(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(GenerateDeleteParams param) async {
    try {
      final data = await dataSource.delete(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }
}

