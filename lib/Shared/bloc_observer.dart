// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    print(
        'onChange -- ${bloc.runtimeType} | ${change.currentState.toString().substring(change.currentState.toString().indexOf('\''), change.currentState.toString().lastIndexOf('\'') + 1)} => ${change.nextState.toString().substring(change.nextState.toString().indexOf('\''), change.nextState.toString().lastIndexOf('\'') + 1)}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
