import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Models/admin_user.dart';
import 'package:jordan_insider/Models/coordinator_user.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Models/tourist_user.dart';
import 'package:jordan_insider/Models/user.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/local/cache_helper.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserDataCubit extends Cubit<UserDataStates> {
  UserDataCubit() : super(UserDataInitialState());

  static UserDataCubit? _cubit;
  static UserDataCubit getInstans() {
    _cubit ??= UserDataCubit();
    return _cubit!;
  }

  User? userData;

  Uint8List? displayimage;

  void changeImage(Uint8List displayimage) {
    this.displayimage = displayimage;
    emit(UserDatachangeImageSuccessState());
  }

  void getUserData({required String token}) {
    if (userData == null) {
      emit(UserGetDataLoadingState());

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      DioHelper.getData(url: GetUserById + decodedToken["UserId"], query: {})
          .then((value) {
        switch (value.data["roleid"]) {
          case 1: //Admin
            userData = Admin.fromJS(value.data, newtoken: token);
            break;

          case 2: //Coordinator.
            userData = Coordinator.fromJS(value.data, newtoken: token);
            break;

          default: //Tourist
            userData = Tourist.fromJS(value.data, newtoken: token);
        }
        emit(UserGetDataSuccessState(userData!));
      }).catchError((error) {
        emit(UserGetDataErrorState(error.toString()));
        logger.e(error);
      });
    }
  }

  Future<bool> updateUser({
    required String name,
    String? phoneNum,
  }) async {
    emit(UserDataUpdateLoadingState());
    if (displayimage != null && userData!.getImageU8L() != displayimage) {
      DioHelper.uploadImageToServer([displayimage]).then((value) {
        String? imageName = value.data["image1"];

        DioHelper.updateData(url: UpdateUser, data: {
          "userid": userData!.getId(),
          "name": name,
          "email": userData!.getEmail(),
          "imagename": imageName,
          "phonenum": phoneNum,
          "password": userData!.getPass()
        }).then((value) {
          userData!.setFullName(name);
          userData!.setImageName(imageName);
          userData!.setImageU8L(displayimage);
          try {
            if (phoneNum != null) {
              userData is Tourist
                  ? (userData as Tourist).setPhoneNum(phoneNum)
                  : (userData as Coordinator).setPhoneNum(phoneNum);
            }
          } catch (e) {
            logger.e(e);
          }
          emit(UserDataUpdateSuccessState());
          return true;
        }).catchError((error) {
          emit(UserDataUpdateErrorState(error.toString()));
          return false;
        });
      }).catchError((error) {
        emit(UserDataUpdateErrorState(error.toString()));
      });
    } else {
      DioHelper.updateData(url: UpdateUser, data: {
        "userid": userData!.getId(),
        "name": name,
        "email": userData!.getEmail(),
        "imagename": userData!.getImageName(),
        "phonenum": phoneNum,
        "password": userData!.getPass()
      }).then((value) {
        userData!.setFullName(name);
        try {
          if (phoneNum != null) {
            userData is Tourist
                ? (userData as Tourist).setPhoneNum(phoneNum)
                : (userData as Coordinator).setPhoneNum(phoneNum);
          }
        } catch (e) {
          logger.e(e);
        }
        emit(UserDataUpdateSuccessState());
        return true;
      }).catchError((error) {
        emit(UserDataUpdateErrorState(error.toString()));
        return false;
      });
    }
    return false;
  }

  Future<void> addReview(Review review,
      {required int receiverId, required String siteName}) async {
    emit(UserDataAddReviewLoadingState());

    DioHelper.postData(
      url: CreateReview,
      data: {
        "touristsiteid": review.getTouristsiteId(),
        "userid": userData!.getId(),
        "rating": review.getReviewRate(),
        "reviewtxt": review.getReviewText()
      },
    ).then((value) {
      emit(UserDataAddReviewSuccessState());
      sendNotification(
          receiverId: receiverId,
          msg: "New Review add to your Site\"$siteName\"");
      (userData as Tourist).addReview(review);
    }).catchError((error) {
      emit(UserDataAddReviewErrorState(error.toString()));
      logger.e(error);
    });
  }

  Future<void> updateReview(int reviewId, Review review) async {
    emit(UserDataAddReviewLoadingState());

    double rate = review.getReviewRate();

    DioHelper.updateData(url: UpdateReview, data: {
      "reviewid": reviewId,
      "touristsiteid": review.getTouristsiteId(),
      "userid": userData!.getId(),
      "rating": rate,
      "reviewtxt": review.getReviewText()
    }).then((value) {
      emit(UserDataAddReviewSuccessState());
      (userData as Tourist).addReview(review);
    }).catchError((error) {
      emit(UserDataAddReviewErrorState(error.toString()));
      logger.e(error);
    });
  }

  void changePass(String newPass) {
    emit(UserChangePassLoadingState());
    String phoneNum = "";
    if (userData is Tourist) {
      phoneNum = (userData as Tourist).getPhoneNum();
    } else if (userData is Coordinator) {
      phoneNum = (userData as Coordinator).getPhoneNum();
    }

    DioHelper.updateData(
      url: UpdateUser,
      data: {
        "userid": userData!.getId(),
        "name": userData!.getFullName(),
        "email": userData!.getEmail(),
        "imagename": userData!.getImageName(),
        "phonenum": phoneNum,
        "password": newPass
      },
    ).then((value) {
      emit(UserChangePassSuccessState());
    }).catchError((error) {
      emit(UserChangePassErrorState());
    });
  }

  void removeFromFav(int attID) {
    emit(UserGetDataLoadingState());

    int userId = UserDataCubit.getInstans().userData!.getId();
    DioHelper.deleteData(
            url: "$DeleteFavoriteByUserAndTouristSite$userId/$attID")
        .then((value) {
      (UserDataCubit.getInstans().userData as Tourist)
          .removeFromFavorite(attID);
      emit(UserGetDataSuccessState(userData!));
    }).catchError((error) {
      emit(UserGetDataErrorState(error.toString()));
    });
  }

  IconData themeIcon = Icons.dark_mode;
  bool isDark = false;
  void changeTheme() {
    emit(ChangeThemeLoadingState());
    if (isDark) {
      themeIcon = Icons.dark_mode;
    } else {
      themeIcon = Icons.light_mode;
    }
    isDark = !isDark;
    CacheHelper.saveData(key: 'theme', value: isDark);
    emit(ChangeThemeSuccessState());
  }
}
