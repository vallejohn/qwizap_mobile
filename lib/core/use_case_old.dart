import 'package:dartz/dartz.dart';

import '../../../../core/exceptions_old/failure.dart';


abstract class UseCaseWithParams<T, P>{
  Future<Either<Failure, T>> call(P params);
}

abstract class UseCaseWithNoParams<T>{
  Future<Either<Failure, T>> call();
}