// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Models/review_user_dto.dart';
import 'package:jordan_insider/Models/tourist_user.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class ShowAttractionCubit extends Cubit<ShowAttractionStates> {
  ShowAttractionCubit() : super(ShowAttractionInitialStates());
  static ShowAttractionCubit? _cubit;

  static ShowAttractionCubit getInstans() {
    _cubit ??= ShowAttractionCubit();
    return _cubit!;
  }

  Attraction? _attraction;
  List<ReviewUserDTO> attractionReviews = [];
  Review? thisUserReview;

  void setAttraction(Attraction attraction) {
    _attraction = attraction;
  }

  Attraction? getAttraction() => _attraction;

  Future<void> getAttractionReviews() async {
    attractionReviews.clear();

    DioHelper.getData(
        url: GetReviewsByTouristSiteId + _attraction!.getID().toString(),
        query: {}).then((value) {
      for (var element in value.data) {
        attractionReviews.add(ReviewUserDTO.fromJSON(element));
      }
    }).catchError((error) {
      emit(ShowAttractionErrorStates(error));
    });
  }

  Future<void> getUserReview(int userId) async {
    DioHelper.getData(
      url: "$GetReviewByUserIdTouristSiteId$userId/${_attraction!.getID()}",
      query: {},
    ).then((value) {
      thisUserReview = Review.fromJSON(value.data);
    }).catchError((error) {
      emit(ShowAttractionErrorStates(error));
    });
  }

  Future<void> getReviews(int userId) async {
    attractionReviews.clear();
    thisUserReview = null;

    emit(ShowAttractionLoadingStates());
    await getAttractionReviews();
    await getUserReview(userId);
    emit(GetReviewByIdSuccessStates());
  }

  Future<void> justEmit() async {
    await Future.delayed(Duration(milliseconds: 500));
    emit(ShowAttractionInitialStates());
  }

  Color favColor = Colors.black;
  IconData favIcon = Icons.favorite_border;
  bool isFav = false;

  void addToFav() {
    isFav = true;
    emit(AddToFavoriteLoadingState());
    int attID = _attraction!.getID();
    int userId = UserDataCubit.getInstans().userData!.getId();
    DioHelper.postData(
        url: CreateFavorite,
        data: {"userid": userId, "touristsiteid": attID}).then((value) {
      favColor = Colors.red;
      favIcon = Icons.favorite;
      (UserDataCubit.getInstans().userData as Tourist).addFavorite(attID);
      emit(AddToFavoriteSuccessState());
    }).catchError((error) {
      emit(AddToFavoriteErrorState());
    });
  }

  void removeFromFav() {
    isFav = false;
    emit(AddToFavoriteLoadingState());
    int attID = _attraction!.getID();
    int userId = UserDataCubit.getInstans().userData!.getId();
    DioHelper.deleteData(
            url: "$DeleteFavoriteByUserAndTouristSite$userId/$attID")
        .then((value) {
      favColor = Colors.black;
      favIcon = Icons.favorite_border;
      (UserDataCubit.getInstans().userData as Tourist)
          .removeFromFavorite(attID);
      emit(AddToFavoriteSuccessState());
    }).catchError((error) {
      emit(AddToFavoriteErrorState());
    });
  }
}
