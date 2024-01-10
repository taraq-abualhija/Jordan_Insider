import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/AcceptSiteCubit/accept_site_cubit.dart';
import 'package:jordan_insider/Controller/AcceptSiteCubit/accept_site_state.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/utils/intent_utils/intent_utils.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AcceptSiteScreen extends StatelessWidget {
  const AcceptSiteScreen({super.key});
  static String route = "AcceptSiteScreen";

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);

    return BlocProvider.value(
      value: AcceptSiteCubit.getInstans(),
      child: BlocConsumer<AcceptSiteCubit, AcceptSiteStates>(
        listener: (context, state) {
          if (state is AcceptSiteErrorStates) {
            //Todo Toast
            MotionToast.warning(
                    toastDuration: Duration(seconds: 3),
                    position: MotionToastPosition.top,
                    animationCurve: Curves.fastLinearToSlowEaseIn,
                    title: Text("Sorry"),
                    description:
                        Text("Something went wrong please try again later"))
                .show(context);
          } else if (state is AcceptSiteSuccessStates) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = AcceptSiteCubit.getInstans();
          if (cubit.getSiteToAcceptScreen() == null &&
              state is AcceptSiteInitialStates) {
            Navigator.pop(context);
          }

          return Scaffold(
            body: ConditionalBuilder(
              condition: (state is! AcceptSiteLoadingStates),
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
                                  itemCount: cubit
                                      .getSiteToAcceptScreen()!
                                      .getImages()
                                      .length,
                                  itemBuilder: (context, index) {
                                    return Image(
                                      image: MemoryImage(
                                        cubit
                                            .getSiteToAcceptScreen()!
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
                            count: (cubit.getSiteToAcceptScreen()!.getImages())
                                .length,
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
                              cubit.getSiteToAcceptScreen()!.getName(),
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
                                    cubit
                                        .getSiteToAcceptScreen()!
                                        .getLocation(),
                                    context: context,
                                  );
                                },
                                child: Text(
                                  cubit.getSiteToAcceptScreen()!.getLocation(),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          /*Description*/ Container(
                            margin: EdgeInsets.all(15.dg),
                            child: Text(cubit
                                .getSiteToAcceptScreen()!
                                .getDescription()),
                          ),
                        ],
                      ),
                    ),
                    ConditionalBuilder(
                      condition: state is! AcceptSiteLoadingStates,
                      builder: (context) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 15.dg),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 5.dg),
                                  child: DefaultButton(
                                    text: "Reject",
                                    onPressed: () {
                                      cubit.rejectSite();
                                    },
                                    gradientColor1: Colors.red,
                                    gradientColor2:
                                        Color.fromARGB(255, 151, 37, 29),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 5.dg),
                                  child: DefaultButton(
                                    text: "Accept",
                                    onPressed: () {
                                      cubit.acceptSite();
                                    },
                                    gradientColor1: Colors.green,
                                    gradientColor2:
                                        Color.fromARGB(255, 33, 116, 36),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    )
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
}
