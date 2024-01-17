import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/SignupCubit/signup_state.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit? _cubit;
  static SignUpCubit getInstans() {
    _cubit ??= SignUpCubit();
    return _cubit!;
  }

  void signUpUser(
      {required String email, required String pass, required String name}) {
    emit(SignUpLoadingState());
    DioHelper.postData(
      url: CreateUser,
      data: {"password": pass, "email": email, 'name': name},
    ).then((value) {
      emit(SignUpSuccessState());
    }).catchError((error) {
      emit(SignUpErrorState(error.toString()));
      logger.e(error);
    });
  }

  IconData eye = Icons.visibility;
  bool isPassShown = false;

  void changePasswordVisibility() {
    isPassShown = !isPassShown;
    eye = isPassShown ? Icons.visibility_off : Icons.visibility;
    emit(SignUpChangePasswordVisibility());
  }
}
