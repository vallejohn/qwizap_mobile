import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  final _log = Logger();

  @override
  void onCreate(BlocBase bloc) {
    _log.d('onCreate -> ${bloc.state}');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    _log.i('onChange -> $change');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _log.e('onError -> $bloc\n$error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    _log.d('onClose -> $bloc');
    super.onClose(bloc);
  }
}
