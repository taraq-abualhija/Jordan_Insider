import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/LoginCubit/login_state.dart';
import 'package:jordan_insider/Models/admin_user.dart';
import 'package:jordan_insider/Models/coordinator_user.dart';
import 'package:jordan_insider/Models/email.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/network/local/cache_helper.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../Models/tourist_user.dart';
import '../../Models/user.dart';
import '../../Shared/network/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit? _cubit;
  static LoginCubit getInstans() {
    _cubit ??= LoginCubit();
    return _cubit!;
  }

  User? thisUser;

  void userLogin({required String email, required String pass}) {
    emit(LoginLoadingState());

    DioHelper.postData(
      url: Login,
      data: {"email": email, "password": pass},
    ).then((value) {
      String userToken = value.data.toString();

      if (userToken != "Unauthorized") {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(userToken);
        CacheHelper.saveData(key: "token", value: userToken);

        DioHelper.getData(url: GetUserById + decodedToken["UserId"], query: {})
            .then((value) {
          switch (value.data["roleid"]) {
            case 1: //Admin
              thisUser = Admin.fromJS(value.data, newtoken: userToken);
              break;

            case 2: //Coordinator.
              thisUser = Coordinator.fromJS(value.data, newtoken: userToken);
              break;

            default: //Tourist
              thisUser = Tourist.fromJS(value.data, newtoken: userToken);
          }
          emit(LoginSuccessState(thisUser));
        }).catchError((error) {
          emit(LoginErrorState(error.toString()));
          logger.e(error);
        });
      } else {
        emit(LoginSuccessState(null));
      }
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
      logger.e(error);
    });
  }

  Future<void> createCoor(
      {required String email, required String pass, String? phone}) async {
    emit(CreateCoordinatorLoadingState());
    String emailBody =
        "You are now registered in Jordan Insider as a Coordinator for our community<br>";
    emailBody += "You Can log in with this account:<br>";
    emailBody += "Email : $email<br>";
    emailBody += "Password: $pass<br><br>";
    emailBody += "Admin";

    Email newEmail = Email(
      sednTo: email,
      emailSubject: "You are now Coordinator in Jordan Insider",
      emailBody: emailBody,
    );

    await DioHelper.postData(
      url: CreateCoordinator,
      data: {"password": pass, "email": email, "phonenum": phone},
    ).then((value) async {
      if (await sendEmail(newEmail)) {
        emit(CreateCoordinatorSuccessState());
      } else {
        emit(CreateCoordinatorErrorState(
            "Sorry Email can't be send now\nBut Coordinator is added!"));
      }
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  Future<bool> sendEmail(Email email) async {
    bool isSent = false;
    await DioHelper.postData(
      url: EmailURL,
      data: {
        "to": email.getSendTo(),
        "plainText": email.getBody(),
        "subject": email.getSubject()
      },
    ).then((value) {
      isSent = true;
    }).catchError((error) {
      logger.e(error);
    });
    return isSent;
  }

  IconData eye = Icons.visibility;
  bool isPassShown = false;

  void changePasswordVisibility() {
    isPassShown = !isPassShown;
    eye = isPassShown ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordVisibility());
  }
}
