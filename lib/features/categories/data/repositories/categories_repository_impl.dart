import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../core/params/categories_params.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource dataSource;

  CategoriesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, CategoriesOperationResult>> fetch(CategoriesFetchParams param) async {
    try {
      final data = await dataSource.fetch(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> create(CategoriesCreateParams param) async {
    try {
      final data = await dataSource.create(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> update(CategoriesUpdateParams param) async {
    try {
      final data = await dataSource.update(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(CategoriesDeleteParams param) async {
    try {
      final data = await dataSource.delete(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }
}

