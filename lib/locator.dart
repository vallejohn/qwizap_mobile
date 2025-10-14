import 'package:get_it/get_it.dart';
import 'package:qwizap_mobile/src/qwizap/data/data_sources/qwizap_data_source.dart';
import 'package:qwizap_mobile/src/qwizap/data/data_sources/qwizap_remote_data_source_impl.dart';
import 'package:qwizap_mobile/src/qwizap/data/repositories/qwizap_repository_impl.dart';
import 'package:qwizap_mobile/src/qwizap/domain/repositories/qwizap_repository.dart';
import 'package:qwizap_mobile/src/qwizap/domain/usecases/generate_multiple_choice_questions_usecase.dart';

import 'core/services/gemini/gemini_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  GeminiService geminiService = GeminiService();
  geminiService.init();

  getIt.registerLazySingleton<QwizapDataSource>(
      () => QwizapRemoteDataSourceImpl(geminiService));

  getIt.registerLazySingleton<QwizapRepository>(
    () => QwizapRepositoryImpl(dataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GenerateMultipleChoiceQuestions(getIt()));
}
