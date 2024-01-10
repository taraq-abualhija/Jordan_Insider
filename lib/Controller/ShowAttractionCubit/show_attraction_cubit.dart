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

  void getAttractionReviews() {
    attractionReviews.clear();
    emit(ShowAttractionLoadingStates());
    DioHelper.getData(
        url: GetReviewsByTouristSiteId + _attraction!.getID().toString(),
        query: {}).then((value) {
      for (var element in value.data) {
        attractionReviews.add(ReviewUserDTO.fromJSON(element));
      }
      emit(GetReviewsByTouristSiteIdSuccessStates());
    }).catchError((error) {
      emit(ShowAttractionErrorStates(error));
    });
  }

  void getUserReview(int userId) {
    emit(ShowAttractionLoadingStates());

    DioHelper.getData(
      url: "$GetReviewByUserIdTouristSiteId$userId/${_attraction!.getID()}",
      query: {},
    ).then((value) {
      thisUserReview = Review.fromJSON(value.data);
      emit(GetReviewByIdSuccessStates());
    }).catchError((error) {
      emit(GetReviewByIdErrorStates(error));
    });
  }

  Future<void> justEmit() async {
    await Future.delayed(Duration(milliseconds: 500));
    emit(ShowAttractionInitialStates());
  }
}
