// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/tourist_user.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/local/cache_helper.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/welcomepage.dart';

Future<Uint8List?> getImageBy(String imageName) async {
  final response = await http.get(
      Uri.parse('http://20.203.96.69/api/TouristSite/api/images/$imageName'));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    return null;
  }
}

void getFavorite({required int userId}) {
  DioHelper.getData(url: GetFavoritesByUserId + userId.toString(), query: {})
      .then((value) {
    for (var element in value.data) {
      (UserDataCubit.getInstans().userData as Tourist)
          .addFavorite(element['touristsiteid']);
    }
  }).catchError((error) {});
}

void userLogOut(BuildContext context) {
  print("Good Bay");

  CacheHelper.deleteData("token");
  CacheHelper.deleteData("rollId");
  UserDataCubit.getInstans().userData = null;
  Navigator.pushNamedAndRemoveUntil(
      context, WelcomePage.route, (route) => false);
}

void sendNotification({
  required int receiverId,
  required String msg,
}) {
  DioHelper.postData(
      url: CreateNotification,
      data: {"userid": receiverId, "notificationtxt": msg});
}
