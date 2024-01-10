import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/Review_Cubit/review_state.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class ReviewCubit extends Cubit<ReviewStates> {
  ReviewCubit() : super(ReviewInitialState());
  static ReviewCubit? _cubit;

  static ReviewCubit getInstans() {
    _cubit ??= ReviewCubit();
    return _cubit!;
  }

  List<Review> reviews = [];

  void getUserReviews(int userId) {
    emit(ReviewLoadingState());

    DioHelper.getData(url: GetReviewsByUserId + userId.toString(), query: {})
        .then((value) async {
      //$value.data; List<JSON>
      reviews.clear();
      for (var element in value.data) {
        Review r = Review.fromJSON(element);
        r.siteName = await getSiteName(r.getTouristsiteId());
        reviews.add(r);
      }
      emit(ReviewSuccessState());
    }).catchError((error) {
      emit(ReviewErrorState(error));
    });
  }

  Future<String> getSiteName(int siteId) async {
    String name = "";
    await DioHelper.getData(
        url: GetTouristSiteById + siteId.toString(), query: {}).then((value) {
      name = value.data["name"];
    }).catchError((error) {
      emit(ReviewErrorState(error.toString()));
    });
    return name;
  }

  void deleteReview(int id) {
    DioHelper.deleteData(url: DeleteReview + id.toString()).then((value) {
      reviews.removeWhere((element) {
        return element.getReviewID() == id;
      });
      emit(ReviewSuccessState());
    }).catchError((error) {
      emit(ReviewErrorState(error));
    });
  }
}
