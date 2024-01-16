// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/coordinator_user.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Models/review_user_dto.dart';
import 'package:jordan_insider/Models/ticket.dart';
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
  Ticket? userTicket;

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

  void buyTicket({required int userID, required SiteEvent event}) {
    emit(BuyTicketLoadingState());
    DioHelper.postData(
        url: CreateTicket,
        data: {'eventid': event.getID(), 'userid': userID}).then((value) async {
      getUserTicketByEventID();
      await DioHelper.getData(
          url: GetUserById + event.getCoordinatorid().toString(),
          query: {}).then((value) {
        Coordinator coor = Coordinator.fromJS(value.data);

        String emailMsg =
            "Dear ${UserDataCubit.getInstans().userData!.getFullName()},<br>";
        emailMsg +=
            "Thank you for purchasing a ticket from Jordan Insider! ❤<br><br>";
        emailMsg +=
            "To confirm your ticket and complete the process, please follow the steps below:<br><br>";
        emailMsg += "1.Contact the Coordinator:<br>";
        emailMsg += "a) Email: ${coor.getEmail()}<br>";
        emailMsg += "b) Phone #: ${coor.getPhoneNum()}<br><br>";
        emailMsg += "2.Make the payment to the Coordinator. <br><br>";
        emailMsg += "3.Congratulations! You now have your ticket.<br><br>";
        emailMsg +=
            "If you have any questions or need further assistance, feel free to reach out to us.<br><br>";
        emailMsg += "Best regards,<br>";
        emailMsg += "Jordan Insider Team.";

        sendEmail(
          email: UserDataCubit.getInstans().userData!.getEmail(),
          subject:
              "Confirmation and Next Steps for Your Jordan Insider Ticket Purchase 🎫",
          msg: emailMsg,
        );
      });

      emit(BuyTicketSuccessState());
    }).catchError((error) {
      emit(BuyTicketErrorState());
    });
  }

  void getUserTicketByEventID() {
    userTicket = null;
    emit(GetUserTicketLoadingState());
    String userID = UserDataCubit.getInstans().userData!.getId().toString();
    String eventID = _attraction!.getID().toString();

    DioHelper.getData(
      url: "$GetTicketsByUserIdAndEventId$userID/$eventID",
      query: {},
    ).then((value) {
      userTicket = Ticket.fromJson(value.data);
      emit(GetUserTicketSuccessState());
    }).catchError((error) {
      emit(GetUserTicketErrorState());
    });
  }
}
