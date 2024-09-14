import 'package:flutter_bloc/flutter_bloc.dart';

class UserState {
  final bool isLoggedIn;
  final bool isGuest;
  UserState({required this.isLoggedIn, required this.isGuest});
}

class UserEvent {}

class LoginEvent extends UserEvent {}

class GuestEvent extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(isLoggedIn: false, isGuest: false));

  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoginEvent) {
      yield UserState(isLoggedIn: true, isGuest: false);
    } else if (event is GuestEvent) {
      yield UserState(isLoggedIn: false, isGuest: true);
    }
  }
}
