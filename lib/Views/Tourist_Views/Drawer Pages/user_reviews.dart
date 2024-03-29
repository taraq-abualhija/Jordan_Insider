import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/Review_Cubit/review_cubit.dart';
import 'package:jordan_insider/Controller/Review_Cubit/review_state.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/welcomepage.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

// ignore: must_be_immutable
class UserReviews extends StatelessWidget {
  UserReviews({super.key});
  static String route = "UserReviews";
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ReviewCubit.getInstans()),
        BlocProvider.value(value: UserDataCubit.getInstans()),
      ],
      child: BlocConsumer<ReviewCubit, ReviewStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var reviewCubit = ReviewCubit.getInstans();
            var userCubit = UserDataCubit.getInstans();
            if (firstTime) {
              reviewCubit.getUserReviews(userCubit.userData!.getId());
              firstTime = false;
            }
            return Scaffold(
                appBar: myAppBar(
                  title: Text(
                    "Reviews",
                    style: TextStyle(fontSize: 25.sp),
                  ),
                ),
                body: ConditionalBuilder(
                  condition: UserDataCubit.getInstans()
                      .userData!
                      .getEmail()
                      .isNotEmpty,
                  builder: (context) => ConditionalBuilder(
                    condition: state is! ReviewLoadingState,
                    builder: (context) {
                      return ListView.builder(
                        itemCount: reviewCubit.reviews.length,
                        itemBuilder: (context, index) {
                          return Center(
                              child: formatReview(reviewCubit.reviews[index]));
                        },
                      );
                    },
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                  fallback: (context) => Center(
                      child: Container(
                    margin: EdgeInsets.all(20.dg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login to see your Reviews",
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        DefaultButton(
                          text: "Go to Login ->",
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, WelcomePage.route, (route) => false);
                          },
                        )
                      ],
                    ),
                  )),
                ));
          }),
    );
  }

  Widget formatReview(Review review) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ShowAttractionCubit.getInstans()),
      ],
      child: BlocConsumer<ShowAttractionCubit, ShowAttractionStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return InkWell(
              onTap: () {
                _showConfirmationDialog(context, review.getReviewID());
              },
              child: Container(
                margin: EdgeInsets.all(15.dg),
                decoration: BoxDecoration(
                  color: UserDataCubit.getInstans().isDark
                      ? Colors.black
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(7, 7),
                      blurRadius: 7,
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(
                    color: !UserDataCubit.getInstans().isDark
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                width: double.infinity,
                height: 100.h,
                child: Container(
                  margin: EdgeInsets.all(5.dg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.siteName,
                        style: TextStyle(fontSize: 18.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          SimpleStarRating(
                            isReadOnly: true,
                            allowHalfRating: true,
                            starCount: 5,
                            rating: review.getReviewRate(),
                            size: 15.sp,
                            spacing: 8,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(review.getReviewText(),
                                overflow: TextOverflow.ellipsis, maxLines: 1),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            review.getReviewTime(),
                            style: TextStyle(
                                color: Colors.black45, fontSize: 15.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _showConfirmationDialog(BuildContext context, int reviewid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => ReviewCubit(),
          child: BlocConsumer<ReviewCubit, ReviewStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return AlertDialog(
                  title: Text('Confirmation'),
                  content: Text('Are you sure you want to Delete this Review?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        ReviewCubit.getInstans().deleteReview(reviewid);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: UserDataCubit.getInstans().isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }
}
