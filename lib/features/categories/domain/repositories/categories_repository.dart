import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/failure.dart';
import '../../core/params/categories_params.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, CategoriesOperationResult>> fetch(CategoriesFetchParams param);
  Future<Either<Failure, bool>> create(CategoriesCreateParams param);
  Future<Either<Failure, bool>> update(CategoriesUpdateParams param);
  Future<Either<Failure, bool>> delete(CategoriesDeleteParams param);
}
