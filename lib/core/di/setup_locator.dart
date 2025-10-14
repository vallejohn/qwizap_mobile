import 'package:get_it/get_it.dart';

import '../../features/categories/domain/usecases/categories_usecase.dart';
import '../../features/categories/data/datasources/categories_remote_data_source.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/presentation/bloc/categories_bloc.dart';

import '../../features/generate/domain/usecases/generate_usecase.dart';
import '../../features/generate/data/datasources/generate_remote_data_source.dart';
import '../../features/generate/data/repositories/generate_repository_impl.dart';
import '../../features/generate/domain/repositories/generate_repository.dart';
import '../../features/generate/presentation/bloc/generate_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Register dependencies here

  // categories registrations
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(sl()),
  );

  // categories use cases
  sl.registerLazySingleton(() => CategoriesFetchUseCase(sl()));
  sl.registerLazySingleton(() => CategoriesCreateUseCase(sl()));
  sl.registerLazySingleton(() => CategoriesUpdateUseCase(sl()));
  sl.registerLazySingleton(() => CategoriesDeleteUseCase(sl()));

  sl.registerFactory(() => CategoriesBloc());

  // generate registrations
  sl.registerLazySingleton<GenerateRemoteDataSource>(
    () => GenerateRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<GenerateRepository>(
    () => GenerateRepositoryImpl(sl()),
  );

  // generate use cases
  sl.registerLazySingleton(() => GenerateFetchUseCase(sl()));
  sl.registerLazySingleton(() => GenerateCreateUseCase(sl()));
  sl.registerLazySingleton(() => GenerateUpdateUseCase(sl()));
  sl.registerLazySingleton(() => GenerateDeleteUseCase(sl()));

  sl.registerFactory(() => GenerateBloc());
}
