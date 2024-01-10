// ignore_for_file: avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Models/review_user_dto.dart';
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
}
