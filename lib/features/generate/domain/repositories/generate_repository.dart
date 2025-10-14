import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/failure.dart';
import '../../core/params/generate_params.dart';

abstract class GenerateRepository {
  Future<Either<Failure, GenerateOperationResult>> fetch(GenerateFetchParams param);
  Future<Either<Failure, bool>> create(GenerateCreateParams param);
  Future<Either<Failure, bool>> update(GenerateUpdateParams param);
  Future<Either<Failure, bool>> delete(GenerateDeleteParams param);
}
