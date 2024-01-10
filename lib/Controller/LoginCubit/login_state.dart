import 'package:jordan_insider/Models/user.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final User? thisUser;

  LoginSuccessState(this.thisUser);
}

class CreateCoordinatorSuccessState extends LoginStates {}

class CreateCoordinatorErrorState extends LoginStates {
  final String error;
  CreateCoordinatorErrorState(this.error);
}

class ChangePasswordVisibility extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String error;
  LoginErrorState(this.error);
}
