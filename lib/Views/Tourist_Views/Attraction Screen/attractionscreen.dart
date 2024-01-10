import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Models/review_user_dto.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Models/tourist_user.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/utils/intent_utils/intent_utils.dart';
import 'package:simple_star_rating/simple_star_rating.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AttractionScreen extends StatelessWidget {
  const AttractionScreen({super.key});
  static String route = "AttractionScreen";

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ShowAttractionCubit.getInstans()),
        BlocProvider.value(value: UserDataCubit.getInstans())
      ],
      child: BlocConsumer<ShowAttractionCubit, ShowAttractionStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShowAttractionCubit.getInstans();
          var userCubit = UserDataCubit.getInstans();
          if (cubit.getAttraction() == null) {
            Navigator.pop(context);
          }

          cubit.getUserReview(userCubit.userData!.getId());
          cubit.getAttractionReviews();

          return Scaffold(
            body: ConditionalBuilder(
              condition: (state is! ShowAttractionLoadingStates),
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          /*Images*/ Stack(
                            children: [
                              SizedBox(
                                height: ScreenHeight(context) / 1.7,
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount:
                                      cubit.getAttraction()!.getImages().length,
                                  itemBuilder: (context, index) {
                                    return Image(
                                      image: MemoryImage(
                                        cubit
                                            .getAttraction()!
                                            .getImages()[index]!,
                                      ),
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  onPageChanged: (index) {},
                                ),
                              ),
                              SafeArea(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 40.w,
                                  height: 40.w,
                                  margin: EdgeInsets.only(left: 15.dg),
                                  decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.circular(200)),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back_ios_new),
                                    color: Colors.black,
                                    iconSize: 25.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenHeight(context) / 100),
                          /*Images Dot*/ SmoothPageIndicator(
                            controller: pageController,
                            count: (cubit.getAttraction()!.getImages()).length,
                            effect: ExpandingDotsEffect(
                              dotColor: Colors.grey,
                              dotHeight: 10.h,
                              expansionFactor: 3,
                              dotWidth: 10.w,
                              spacing: 5,
                            ),
                          ),
                          /*Title*/ Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 15.dg, left: 15.dg),
                            child: Text(
                              cubit.getAttraction()!.getName(),
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          /*Location*/ Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on, color: Colors.red),
                              TextButton(
                                onPressed: () async {
                                  IntentUtils.getLocationByName(
                                    cubit.getAttraction()!.getLocation(),
                                    context: context,
                                  );
                                },
                                child: Text(
                                  cubit.getAttraction()!.getLocation(),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          /*State & fav.*/ Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.dg),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Open",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: "Open" == "Open"
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                Icon(Icons.favorite_border, size: 25.sp),
                                // Icon(Icons.favorite, color: Colors.red, size: 25.sp),
                              ],
                            ),
                          ),
                          /*Description*/ Container(
                            margin: EdgeInsets.all(15.dg),
                            child:
                                Text(cubit.getAttraction()!.getDescription()),
                          ),
                        ],
                      ),
                    ),
                    /*Reviews*/ ConditionalBuilder(
                      condition: cubit.getAttraction() is Site,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.all(10.dg),
                          child: Container(
                            margin: EdgeInsets.only(left: 15.dg),
                            child: TextButton(
                                onPressed: () {
                                  if (userCubit.userData is Tourist) {
                                    addReviewDialog(
                                      cubit: cubit,
                                      userCubit: userCubit,
                                      context: context,
                                    );
                                  } else {
                                    showReviews(context);
                                  }
                                },
                                child: Text(
                                  "Reviews",
                                  style: TextStyle(fontSize: 20.sp),
                                )),
                          ),
                        );
                      },
                      fallback: (context) => Container(),
                    ),
                  ],
                );
              },
              fallback: (context) {
                return Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }

  showReviews(BuildContext context) {
    var attractionCubit = ShowAttractionCubit.getInstans();
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // width: double.infinity,
          padding: EdgeInsets.all(15.dg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reviews",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: mainColor,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: attractionCubit.attractionReviews.length,
                  itemBuilder: (context, index) {
                    return formatReview(
                        attractionCubit.attractionReviews[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget formatReview(ReviewUserDTO review) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ConditionalBuilder(
                    condition: review.getReviewerImage() != null,
                    builder: (context) {
                      return CircleAvatar(
                        backgroundImage:
                            MemoryImage(review.getReviewerImage()!),
                      );
                    },
                    fallback: (context) => CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/unknown-person.png"),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.getReviewerName(),
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        review.getReviewDate(),
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SimpleStarRating(
              // filledIcon: Icon(Icons.star),
              isReadOnly: true,
              allowHalfRating: true,
              starCount: 5,
              rating: review.getReviewRate(),
              size: 20.sp,
              spacing: 8,
            )
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Text(review.getReviewTxt() ?? ""),
        ),
      ],
    );
  }

  addReviewDialog({
    required ShowAttractionCubit cubit,
    required UserDataCubit userCubit,
    required BuildContext context,
  }) {
    double reviewRate = 0;
    final reviewText = TextEditingController();

    reviewRate = cubit.thisUserReview?.getReviewRate() ?? 0;
    reviewText.text = cubit.thisUserReview?.getReviewText() ?? "";
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.dg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add review",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: mainColor,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      userCubit.userData!.getFullName(),
                      style: TextStyle(color: Colors.grey),
                      maxLines: 1,
                    ),
                  ),
                  SimpleStarRating(
                    isReadOnly: false,
                    allowHalfRating: true,
                    starCount: 5,
                    rating: reviewRate,
                    size: 20.sp,
                    onRated: (rate) {
                      reviewRate = rate!;
                    },
                    spacing: 8,
                  ),
                ],
              ),
              SizedBox(height: ScreenHeight(context) / 100),
              DefaultFormField(
                hintText: "Describe your experienece (optional)",
                controller: reviewText,
                validate: (val) {
                  return null;
                },
              ),
              SizedBox(height: ScreenHeight(context) / 100),
              BlocConsumer<UserDataCubit, UserDataStates>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return ConditionalBuilder(
                      condition: state is! UserDataAddReviewLoadingState,
                      builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultButton(
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: "Cancel",
                              width: 150,
                            ),
                            DefaultButton(
                              color: Colors.green,
                              onPressed: () {
                                if (cubit.thisUserReview == null) {
                                  userCubit
                                      .addReview(Review(
                                          cubit.getAttraction()!.getID(),
                                          userCubit.userData!.getFullName(),
                                          reviewText.text,
                                          "",
                                          reviewRate))
                                      .then((value) {
                                    state is UserDataAddReviewSuccessState
                                        ? Navigator.pop(context)
                                        : null;
                                  });
                                } else {
                                  userCubit
                                      .updateReview(
                                          cubit.thisUserReview!.getReviewID(),
                                          Review(
                                              cubit.getAttraction()!.getID(),
                                              userCubit.userData!.getFullName(),
                                              reviewText.text,
                                              "",
                                              reviewRate))
                                      .then((value) {
                                    state is UserDataAddReviewSuccessState
                                        ? Navigator.pop(context)
                                        : null;
                                  });
                                }
                              },
                              text: "Post",
                              width: 150,
                            ),
                          ],
                        );
                      },
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    );
                  }),
              SizedBox(height: ScreenHeight(context) / 50),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showReviews(context);
                  },
                  child: Text(
                    "See all reviews ->",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}