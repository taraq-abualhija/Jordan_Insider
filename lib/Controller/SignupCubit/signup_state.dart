abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

class SignUpSuccessState extends SignUpStates {}

class SignUpChangePasswordVisibility extends SignUpStates {}

class SignUpErrorState extends SignUpStates {
  final String error;
  SignUpErrorState(this.error);
}
