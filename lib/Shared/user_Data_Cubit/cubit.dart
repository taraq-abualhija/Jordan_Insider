// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Shared/user_Data_Cubit/states.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(InitialState());
  static DataCubit get(BuildContext context) => BlocProvider.of(context);

//! Current User
  String userEmail = "NULL";
  String userPass = "NULL";
  String userName = "Guest";
  String userImage = "assets/images/man-person.jpg";
  String userPhoneNo = "NULL";
  String userRoll = "Tourist";
//! Current User

  void setUserData({
    required String email,
    required String pass,
    required String name,
    required String image,
    required String phone,
    required String roll,
  }) {
    userEmail = email;
    userPass = pass;
    userName = name;
    userImage = image;
    userPhoneNo = phone;
    userRoll = roll;
    emit(SetUserDataState());
  }

  void deletUser() {
    userEmail = "NULL";
    userPass = "NULL";
    userName = "Guest";
    userImage = "assets/images/man-person.jpg";
    userPhoneNo = "NULL";
    userRoll = "Tourist";
  }

  void changeInfo(
      {required String email, required String name, required String phone}) {
    userEmail = email;
    userName = name;
    userPhoneNo = phone;
    emit(ChangeUserDataState());
  }

  void changePlayerName(String name) {
    emit(ChangeNameState());
  }
}
