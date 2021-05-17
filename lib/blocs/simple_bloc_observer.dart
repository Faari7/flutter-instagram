import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit bloc, Object error, StackTrace stacktrace) async {
    print(bloc);
    print(error);
    print(stacktrace);
    super.onError(bloc, error, stacktrace);
  }

  @override
  void onChange(Cubit bloc, Change change) {
    print(bloc);
    print(change);
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }
}
