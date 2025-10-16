import 'dart:io';

void main(List<String> args)async {
  if (args.isEmpty) {
    print('❌ Please provide a feature name. Example:');
    print('flutter pub run tool/clean_arch_generator.dart profile');
    return;
  }

  String toPascalCase(String text) {
    return text.split('_')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join();
  }

  final feature = args.first.toLowerCase();
  final featurePascal = toPascalCase(feature);

  // === DEFINE PATHS ===
  final coreDir = Directory('lib/core');
  final diDir = Directory('${coreDir.path}/di');
  final modelsDir = Directory('${coreDir.path}/models');
  final exceptionsDir = Directory('${coreDir.path}/exceptions');
  final themeDir = Directory('${coreDir.path}/theme');
  final constantsDir = Directory('${coreDir.path}/constants');
  final utilsDir = Directory('${coreDir.path}/utils');
  final errorDir = Directory('${coreDir.path}/error');

  final featureDir = Directory('lib/features/$feature');
  final featureCoreDir = Directory('${featureDir.path}/core');
  final dataDir = Directory('${featureDir.path}/data');
  final domainDir = Directory('${featureDir.path}/domain');
  final presentationDir = Directory('${featureDir.path}/presentation');

  for (final dir in [
    coreDir,
    diDir,
    modelsDir,
    themeDir,
    exceptionsDir,
    constantsDir,
    utilsDir,
    errorDir,
    dataDir,
    featureCoreDir,
    domainDir,
    presentationDir,
  ]) {
    if (!dir.existsSync()) dir.createSync(recursive: true);
  }

  // === CREATE OPERATION RESULT FILE ===
  final opResultFile = File('${modelsDir.path}/operation_result.dart');
  if (!opResultFile.existsSync()) {
    opResultFile.writeAsStringSync('''
import 'package:equatable/equatable.dart';

class OperationResult<T> extends Equatable {
  final String? message;
  final T? data;

  const OperationResult({
    this.message,
    this.data,
  });

  /// Named constructor for clarity
  const OperationResult.success({
    this.data,
    this.message,
  });

  @override
  List<Object?> get props => [message, data];

  @override
  String toString() =>
      'OperationResult(message: \$message, data: \$data)';
}

''');
  }

  // === CREATE API EXCEPTION FILES ===
  final exceptionFile = File('${exceptionsDir.path}/api_exception.dart');
  if (!exceptionFile.existsSync()) {
    exceptionFile.writeAsStringSync('''
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data; // optional response body

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() =>
      'ApiException(statusCode: \$statusCode, message: \$message)';
  
  /// Factory for easily creating exceptions from HTTP/Dio responses
  factory ApiException.fromResponse({
    required int? statusCode,
    dynamic data,
  }) {
    String message;

    if(statusCode == null){
      message = 'No response from server. Please check your connection.';
    } else if (statusCode >= 500) {
      message = 'Server error occurred. Please try again later.';
    } else if (statusCode == 404) {
      message = 'Requested resource not found.';
    } else if (statusCode == 401 || statusCode == 403) {
      message = 'Unauthorized request.';
    } else if (statusCode >= 400) {
      message = 'Something went wrong. Please check your request.';
    } else {
      message = 'Unexpected error occurred.';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  /// For network-level (no response) errors
  factory ApiException.network([String? message]) => ApiException(
        message: message ?? 'No internet connection. Please try again.',
      );
}

''');
  }

  final failureFile = File('${exceptionsDir.path}/failure.dart');
  if (!failureFile.existsSync()) {
    failureFile.writeAsStringSync('''
import 'package:freezed_annotation/freezed_annotation.dart';
import 'api_exception.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _\$Failure{
  const factory Failure.apiException(ApiException exception) = _APIException;
}

''');
  }

  final useCaseFile = File('${coreDir.path}/use_case.dart');
  if (!useCaseFile.existsSync()) {
    useCaseFile.writeAsStringSync('''
import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';


abstract class UseCaseWithParams<T, P>{
  Future<Either<Failure, T>> call(P params);
}

abstract class UseCaseWithNoParams<T>{
  Future<Either<Failure, T>> call();
}

''');
  }


  // === CREATE CORE FILES ===
  final themeFile = File('${themeDir.path}/app_theme.dart');
  if (!themeFile.existsSync()) {
    themeFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'swatches.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: primarySwatch,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primarySwatch,
      accentColor: secondarySwatch,
      errorColor: errorSwatch,
    ).copyWith(
      secondary: secondarySwatch,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onError: Colors.white,
      onSurface: Colors.black,
    ),
  );
}
''');
  }

  // === CREATE SWATCH FILES ===
  final swatchFile = File('${themeDir.path}/swatches.dart');
  if (!swatchFile.existsSync()) {
    swatchFile.writeAsStringSync('''
import 'package:flutter/material.dart';

/// 🌈 App Color Palette
/// Basic MaterialColor swatches (50–900) for consistent theming.

const MaterialColor primarySwatch = MaterialColor(
  0xFF3F51B5, // Indigo
  <int, Color>{
    50: Color(0xFFE8EAF6),
    100: Color(0xFFC5CAE9),
    200: Color(0xFF9FA8DA),
    300: Color(0xFF7986CB),
    400: Color(0xFF5C6BC0),
    500: Color(0xFF3F51B5),
    600: Color(0xFF3949AB),
    700: Color(0xFF303F9F),
    800: Color(0xFF283593),
    900: Color(0xFF1A237E),
  },
);

const MaterialColor secondarySwatch = MaterialColor(
  0xFFFF9800, // Orange
  <int, Color>{
    50: Color(0xFFFFF3E0),
    100: Color(0xFFFFE0B2),
    200: Color(0xFFFFCC80),
    300: Color(0xFFFFB74D),
    400: Color(0xFFFFA726),
    500: Color(0xFFFF9800),
    600: Color(0xFFFB8C00),
    700: Color(0xFFF57C00),
    800: Color(0xFFEF6C00),
    900: Color(0xFFE65100),
  },
);

const MaterialColor successSwatch = MaterialColor(
  0xFF4CAF50, // Green
  <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF4CAF50),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  },
);

const MaterialColor warningSwatch = MaterialColor(
  0xFFFFC107, // Amber
  <int, Color>{
    50: Color(0xFFFFF8E1),
    100: Color(0xFFFFECB3),
    200: Color(0xFFFFE082),
    300: Color(0xFFFFD54F),
    400: Color(0xFFFFCA28),
    500: Color(0xFFFFC107),
    600: Color(0xFFFFB300),
    700: Color(0xFFFFA000),
    800: Color(0xFFFF8F00),
    900: Color(0xFFFF6F00),
  },
);

const MaterialColor errorSwatch = MaterialColor(
  0xFFF44336, // Red
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFF44336),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  },
);


''');
  }

  final featureCoreParamsDir = Directory('${featureCoreDir.path}/params');
  featureCoreParamsDir.createSync(recursive: true);

  final featureCoreParamFile =
  File('${featureCoreParamsDir.path}/${feature}_params.dart');
  featureCoreParamFile.writeAsStringSync('''
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/operation_result.dart';
import '../../data/models/${feature}_model.dart';
part '${feature}_params.freezed.dart';
part '${feature}_params.g.dart';

typedef ${featurePascal}OperationResult = OperationResult<${featurePascal}Model>;

@freezed
class ${featurePascal}FetchParams with _\$${featurePascal}FetchParams {
  const factory ${featurePascal}FetchParams({
    //Modify this to your needs
    required String id,
  }) = _${featurePascal}FetchParams;

  factory ${featurePascal}FetchParams.fromJson(Map<String, dynamic> json) =>
      _\$${featurePascal}FetchParamsFromJson(json);
}

@freezed
class ${featurePascal}CreateParams with _\$${featurePascal}CreateParams {
  const factory ${featurePascal}CreateParams({
    //Modify this to your needs
    required String id,
  }) = _${featurePascal}CreateParams;

  factory ${featurePascal}CreateParams.fromJson(Map<String, dynamic> json) =>
      _\$${featurePascal}CreateParamsFromJson(json);
}

@freezed
class ${featurePascal}UpdateParams with _\$${featurePascal}UpdateParams {
  const factory ${featurePascal}UpdateParams({
    //Modify this to your needs
    required String id,
  }) = _${featurePascal}UpdateParams;

  factory ${featurePascal}UpdateParams.fromJson(Map<String, dynamic> json) =>
      _\$${featurePascal}UpdateParamsFromJson(json);
}

@freezed
class ${featurePascal}DeleteParams with _\$${featurePascal}DeleteParams {
  const factory ${featurePascal}DeleteParams({
    //Modify this to your needs
    required String id,
  }) = _${featurePascal}DeleteParams;

  factory ${featurePascal}DeleteParams.fromJson(Map<String, dynamic> json) =>
      _\$${featurePascal}DeleteParamsFromJson(json);
}


''');


  // === FEATURE: DATA LAYER ===
  final dataSourceDir = Directory('${dataDir.path}/datasources');
  final modelDir = Directory('${dataDir.path}/models');
  final repoImplDir = Directory('${dataDir.path}/repositories');
  dataSourceDir.createSync(recursive: true);
  modelDir.createSync(recursive: true);
  repoImplDir.createSync(recursive: true);

  // datasource
  final dataSourceFile =
  File('${dataSourceDir.path}/${feature}_remote_data_source.dart');
  dataSourceFile.writeAsStringSync('''
 import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../core/params/${feature}_params.dart';
import '../models/${feature}_model.dart';

abstract class ${featurePascal}RemoteDataSource {
  Future<${featurePascal}OperationResult> fetch(${featurePascal}FetchParams param);
  Future<bool> create(${featurePascal}CreateParams param);
  Future<bool> update(${featurePascal}UpdateParams param);
  Future<bool> delete(${featurePascal}DeleteParams param);
}

class ${featurePascal}RemoteDataSourceImpl implements ${featurePascal}RemoteDataSource {
  final apiService = ApiService();
  
  @override
  Future<${featurePascal}OperationResult> fetch(${featurePascal}FetchParams param) async {
    final response = await apiService.get(
      ApiEndpoints.fetch$featurePascal,
    );

    return ${featurePascal}OperationResult.success(
      data: ${featurePascal}Model.fromJson(response.data),
    );
  }

  @override
  Future<bool> create(${featurePascal}CreateParams param) async {
    final response = await apiService.post(
      ApiEndpoints.create$featurePascal,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }

  @override
  Future<bool> update(${featurePascal}UpdateParams param) async {
    final response = await apiService.post(
      ApiEndpoints.update$featurePascal,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }

  @override
  Future<bool> delete(${featurePascal}DeleteParams param) async {
    final response = await apiService.post(
      ApiEndpoints.delete$featurePascal,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }
}

''');

  // model
  final modelFile = File('${modelDir.path}/${feature}_model.dart');
  modelFile.writeAsStringSync('''
import 'package:freezed_annotation/freezed_annotation.dart';
part '${feature}_model.freezed.dart';
part '${feature}_model.g.dart';

@freezed
class ${featurePascal}Model with _\$${featurePascal}Model {
  const factory ${featurePascal}Model({
    String? id,
    @Default('') String name,
  }) = _${featurePascal}Model;

  factory ${featurePascal}Model.fromJson(Map<String, dynamic> json) =>
      _\$${featurePascal}ModelFromJson(json);
}
''');

  // repository (domain interface)
  final domainRepoDir = Directory('${domainDir.path}/repositories');
  domainRepoDir.createSync(recursive: true);
  final domainRepoFile =
  File('${domainRepoDir.path}/${feature}_repository.dart');
  domainRepoFile.writeAsStringSync('''
import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/failure.dart';
import '../../core/params/${feature}_params.dart';

abstract class ${featurePascal}Repository {
  Future<Either<Failure, ${featurePascal}OperationResult>> fetch(${featurePascal}FetchParams param);
  Future<Either<Failure, bool>> create(${featurePascal}CreateParams param);
  Future<Either<Failure, bool>> update(${featurePascal}UpdateParams param);
  Future<Either<Failure, bool>> delete(${featurePascal}DeleteParams param);
}
''');

  // repository (domain interface)
  final domainUseCaseDir = Directory('${domainDir.path}/usecases');
  domainUseCaseDir.createSync(recursive: true);
  final domainUseCaseFile =
  File('${domainUseCaseDir.path}/${feature}_usecase.dart');
  domainUseCaseFile.writeAsStringSync('''
import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/use_case.dart';
import '../../core/params/${feature}_params.dart';
import '../repositories/${feature}_repository.dart';

class ${featurePascal}FetchUseCase extends UseCaseWithParams<${featurePascal}OperationResult, ${featurePascal}FetchParams>{
  final ${featurePascal}Repository _repository;

  ${featurePascal}FetchUseCase(this._repository);

  @override
  Future<Either<Failure, ${featurePascal}OperationResult>> call(param) {
    return _repository.fetch(param);
  }
}

class ${featurePascal}CreateUseCase extends UseCaseWithParams<bool, ${featurePascal}CreateParams>{
  final ${featurePascal}Repository _repository;

  ${featurePascal}CreateUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(${featurePascal}CreateParams param) {
    return _repository.create(param);
  }
}

class ${featurePascal}UpdateUseCase extends UseCaseWithParams<bool, ${featurePascal}UpdateParams>{
  final ${featurePascal}Repository _repository;

  ${featurePascal}UpdateUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(${featurePascal}UpdateParams param) {
    return _repository.update(param);
  }
}

class ${featurePascal}DeleteUseCase extends UseCaseWithParams<bool, ${featurePascal}DeleteParams>{
  final ${featurePascal}Repository _repository;

  ${featurePascal}DeleteUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(${featurePascal}DeleteParams param) {
    return _repository.delete(param);
  }
}  
''');

  // repository implementation
  final repoImplFile =
  File('${repoImplDir.path}/${feature}_repository_impl.dart');
  repoImplFile.writeAsStringSync('''
import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../core/params/${feature}_params.dart';
import '../../domain/repositories/${feature}_repository.dart';
import '../datasources/${feature}_remote_data_source.dart';

class ${featurePascal}RepositoryImpl implements ${featurePascal}Repository {
  final ${featurePascal}RemoteDataSource dataSource;

  ${featurePascal}RepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, ${featurePascal}OperationResult>> fetch(${featurePascal}FetchParams param) async {
    try {
      final data = await dataSource.fetch(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> create(${featurePascal}CreateParams param) async {
    try {
      final data = await dataSource.create(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> update(${featurePascal}UpdateParams param) async {
    try {
      final data = await dataSource.update(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(${featurePascal}DeleteParams param) async {
    try {
      final data = await dataSource.delete(param);
      return Right(data);
    } on ApiException catch (e) {
      return Left(Failure.apiException(e));
    }
  }
}

''');

  // === FEATURE: BLOC ===
  final blocDir = Directory('${presentationDir.path}/bloc');
  blocDir.createSync(recursive: true);
  final eventFile = File('${blocDir.path}/${feature}_event.dart');
  final stateFile = File('${blocDir.path}/${feature}_state.dart');
  final blocFile = File('${blocDir.path}/${feature}_bloc.dart');

  eventFile.writeAsStringSync('''
part of '${feature}_bloc.dart';

@freezed
class ${featurePascal}Event with _\$${featurePascal}Event {
  const factory ${featurePascal}Event.fetch(${featurePascal}FetchParams param) = _Fetch;
  const factory ${featurePascal}Event.create(${featurePascal}CreateParams param) = _Create;
  const factory ${featurePascal}Event.update(${featurePascal}UpdateParams param) = _Update;
  const factory ${featurePascal}Event.delete(${featurePascal}DeleteParams param) = _Delete;
}
''');

  stateFile.writeAsStringSync('''
part of '${feature}_bloc.dart';

enum ${featurePascal}FetchStatus {initial, loading, success, failure}
enum ${featurePascal}CreateStatus {initial, loading, success, failure}
enum ${featurePascal}UpdateStatus {initial, loading, success, failure}
enum ${featurePascal}DeleteStatus {initial, loading, success, failure}

@freezed
class ${featurePascal}State with _\$${featurePascal}State {
  const factory ${featurePascal}State({
    @Default(${featurePascal}FetchStatus.initial) ${featurePascal}FetchStatus fetchStatus,
    @Default(${featurePascal}CreateStatus.initial) ${featurePascal}CreateStatus createStatus,
    @Default(${featurePascal}UpdateStatus.initial) ${featurePascal}UpdateStatus updateStatus,
    @Default(${featurePascal}DeleteStatus.initial) ${featurePascal}DeleteStatus deleteStatus,
    @Default('') String message,
    ${featurePascal}Model? data,
  }) = _${featurePascal}State;
}

''');

  blocFile.writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../core/params/${feature}_params.dart';
import '../../data/models/${feature}_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/${feature}_usecase.dart';

part '${feature}_event.dart';
part '${feature}_state.dart';
part '${feature}_bloc.freezed.dart';

class ${featurePascal}Bloc extends Bloc<${featurePascal}Event, ${featurePascal}State> {
  final _fetchUseCase = GetIt.instance<${featurePascal}FetchUseCase>();
  final _createUseCase = GetIt.instance<${featurePascal}CreateUseCase>();
  final _updateUseCase = GetIt.instance<${featurePascal}UpdateUseCase>();
  final _deleteUseCase = GetIt.instance<${featurePascal}DeleteUseCase>();

  ${featurePascal}Bloc() : super(const ${featurePascal}State()) {
    on<_Fetch>(_onFetch);
    on<_Create>(_onCreate);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
  }

  Future<void> _onFetch(_Fetch event, Emitter<${featurePascal}State> emit) async {
    emit(state.copyWith(fetchStatus: ${featurePascal}FetchStatus.loading));
    final result = await _fetchUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          fetchStatus: ${featurePascal}FetchStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(
        state.copyWith(
          fetchStatus: ${featurePascal}FetchStatus.success,
          data: data.data,
        ),
      ),
    );
  }

  Future<void> _onCreate(_Create event, Emitter<${featurePascal}State> emit) async {
    emit(state.copyWith(createStatus: ${featurePascal}CreateStatus.loading));
    final result = await _createUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          createStatus: ${featurePascal}CreateStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(createStatus: ${featurePascal}CreateStatus.success)),
    );
  }

  Future<void> _onUpdate(_Update event, Emitter<${featurePascal}State> emit) async {
    emit(state.copyWith(updateStatus: ${featurePascal}UpdateStatus.loading));
    final result = await _updateUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          updateStatus: ${featurePascal}UpdateStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(updateStatus: ${featurePascal}UpdateStatus.success)),
    );
  }

  Future<void> _onDelete(_Delete event, Emitter<${featurePascal}State> emit) async {
    emit(state.copyWith(deleteStatus: ${featurePascal}DeleteStatus.loading));
    final result = await _deleteUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          deleteStatus: ${featurePascal}DeleteStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(deleteStatus: ${featurePascal}DeleteStatus.success)),
    );
  }
}

''');

  // === PAGE ===
  final pageDir = Directory('${presentationDir.path}/pages');
  pageDir.createSync(recursive: true);
  final pageFile = File('${pageDir.path}/${feature}_page.dart');
  pageFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/setup_locator.dart';
import '../../core/params/${feature}_params.dart';
import '../bloc/${feature}_bloc.dart';

class ${featurePascal}Page extends StatefulWidget {
  const ${featurePascal}Page({super.key});

  @override
  State<${featurePascal}Page> createState() => _${featurePascal}PageState();
}

class _${featurePascal}PageState extends State<${featurePascal}Page> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<${featurePascal}Bloc>()..add(const ${featurePascal}Event.fetch(${featurePascal}FetchParams(id: ''))),
      child: Scaffold(
        appBar: AppBar(title: const Text('$featurePascal Page')),
        body: BlocBuilder<${featurePascal}Bloc, ${featurePascal}State>(
          builder: (context, state) {
            if (state.fetchStatus == ${featurePascal}FetchStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.message.isNotEmpty) {
              return Center(child: Text('Error: \${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

''');

// === AUTO REGISTER IN setup_locator.dart ===
  final locatorFile = File('${diDir.path}/setup_locator.dart');

  if (!locatorFile.existsSync()) {
    locatorFile.writeAsStringSync('''
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Register dependencies here
}
''');
  }

  String locatorContent = locatorFile.readAsStringSync();

// === ADD IMPORTS ===
  final importBlock = '''
import '../../features/$feature/domain/usecases/${feature}_usecase.dart';
import '../../features/$feature/data/datasources/${feature}_remote_data_source.dart';
import '../../features/$feature/data/repositories/${feature}_repository_impl.dart';
import '../../features/$feature/domain/repositories/${feature}_repository.dart';
import '../../features/$feature/presentation/bloc/${feature}_bloc.dart';
''';

// === ADD REGISTRATIONS ===
  final registrationBlock = '''
  // $feature registrations
  sl.registerLazySingleton<${featurePascal}RemoteDataSource>(
    () => ${featurePascal}RemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<${featurePascal}Repository>(
    () => ${featurePascal}RepositoryImpl(sl()),
  );

  // $feature use cases
  sl.registerLazySingleton(() => ${featurePascal}FetchUseCase(sl()));
  sl.registerLazySingleton(() => ${featurePascal}CreateUseCase(sl()));
  sl.registerLazySingleton(() => ${featurePascal}UpdateUseCase(sl()));
  sl.registerLazySingleton(() => ${featurePascal}DeleteUseCase(sl()));

  sl.registerFactory(() => ${featurePascal}Bloc());
''';

// === INSERT IMPORTS AT TOP ===
  if (!locatorContent.contains('${feature}_remote_data_source.dart')) {
    final insertIndex = locatorContent.indexOf('final sl');
    locatorContent = locatorContent.replaceRange(insertIndex, insertIndex, '$importBlock\n');
  }

// === INSERT REGISTRATIONS INTO setupLocator() ===
  if (!locatorContent.contains('${featurePascal}Bloc')) {
    locatorContent = locatorContent.replaceAllMapped(
      RegExp(r'Future<void> setupLocator\(\) async \{([\s\S]*?)\}'),
          (match) {
        final body = match.group(1) ?? '';
        return 'Future<void> setupLocator() async {$body\n$registrationBlock\n}';
      },
    );
  }

// === WRITE BACK TO FILE ===
  locatorFile.writeAsStringSync(locatorContent);

// === FORMAT AFTER WRITING (OPTIONAL) ===
  try {
    Process.runSync('dart', ['format', locatorFile.path]);
  } catch (_) {}

  print('✅ Clean Architecture for "$feature" generated successfully!');


  print('🚀 Generating API service files...');

  final directories = [
    'lib/core/config',
    'lib/core/network',
  ];

  // Create directories
  for (final dir in directories) {
    await Directory(dir).create(recursive: true);
  }

  // Create files
  await _createFile('lib/core/config/api_config.dart', _apiConfigContent);
  await generateApiEndpoints(feature);
  await _createFile('lib/core/network/dio_client.dart', _dioClientContent);
  await _createFile('lib/core/network/api_service.dart', _apiServiceContent);

  print('✅ API service files generated successfully!');
}


Future<void> generateApiEndpoints(String feature) async {
  final coreDir = Directory('lib/core/network');
  if (!coreDir.existsSync()) {
    coreDir.createSync(recursive: true);
  }

  final apiFile = File('${coreDir.path}/api_endpoints.dart');

  // === CREATE FILE IF NOT EXISTS ===
  if (!apiFile.existsSync()) {
    apiFile.writeAsStringSync('''
class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
}
''');
  }

  String apiContent = apiFile.readAsStringSync();

  // === PREPARE NAMING ===
  final featurePascal =
      feature[0].toUpperCase() + feature.substring(1).toLowerCase();
  final featureLower = feature.toLowerCase();

  // === DEFINE ENDPOINT BLOCK ===
  final endpointBlock = '''
  
  // $featurePascal endpoints
  static const String fetch$featurePascal = '/$featureLower';
  static const String create$featurePascal = '/$featureLower-create';
  static const String update$featurePascal = '/$featureLower-update';
  static const String delete$featurePascal = '/$featureLower-delete';
''';

  // === SKIP IF ALREADY EXISTS ===
  if (apiContent.contains('fetch$featurePascal')) {
    print('⚠️  Endpoints for "$feature" already exist. Skipped.');
    return;
  }

  // === INSERT BLOCK ABOVE THE CLOSING BRACE ===
  apiContent = apiContent.replaceFirst(
    RegExp(r'\}\s*$'),
    '$endpointBlock\n}',
  );

  apiFile.writeAsStringSync(apiContent);

  print('✅ Added API endpoints for "$feature"');

  // === FORMAT FILE AFTER WRITING (OPTIONAL) ===
  try {
    Process.runSync('dart', ['format', apiFile.path]);
  } catch (_) {}
}

Future<void> _createFile(String path, String content) async {
  final file = File(path);
  if (await file.exists()) {

    return;
  }
  await file.writeAsString(content.trim());
  print('📝 Created $path');
}

//
// ---------------- File Contents ----------------
//

const _apiConfigContent = '''
class ApiConfig {
  static const String devBaseUrl = 'https://dev.example.com/api';
  static const String prodBaseUrl = 'https://api.example.com/api';

  static const String baseUrl = prodBaseUrl;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
''';

const _dioClientContent = '''
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Example: Add Bearer token if needed
        // final token = await AuthStorage.getToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer \$token';
        // }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Example: handle 401 here and refresh token
        return handler.next(e);
      },
    ));
  }
}
''';

const _apiServiceContent = '''
import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    if (error.response != null) {
      return Exception('Error: \${error.response?.statusCode} - \${error.response?.data}');
    } else {
      return Exception('Network Error: \${error.message}');
    }
  }
}
''';

