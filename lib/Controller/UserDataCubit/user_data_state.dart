import 'package:jordan_insider/Models/user.dart';

abstract class UserDataStates {}

class UserDataInitialState extends UserDataStates {}

class UserGetDataLoadingState extends UserDataStates {}

class UserDatachangeImageSuccessState extends UserDataStates {}

class UserGetDataSuccessState extends UserDataStates {
  final User user;
  UserGetDataSuccessState(this.user);
}

class UserGetDataErrorState extends UserDataStates {
  final String error;
  UserGetDataErrorState(this.error);
}

class UserDataUpdateLoadingState extends UserDataStates {}

class UserDataAddReviewLoadingState extends UserDataStates {}

class UserDataAddReviewSuccessState extends UserDataStates {}

class UserDataUpdateErrorState extends UserDataStates {
  final String error;
  UserDataUpdateErrorState(this.error);
}

class UserDataAddReviewErrorState extends UserDataStates {
  final String error;
  UserDataAddReviewErrorState(this.error);
}

class UserDataUpdateSuccessState extends UserDataStates {}
