import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_cubit.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_state.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_cubit.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';
import 'package:jordan_insider/Views/Tourist_Views/Search_Screen/searchscreen.dart';
import 'package:video_player/video_player.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});
  static String route = "DetailsScreen";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ImageProccessingCubit.getInstans()),
        BlocProvider.value(value: ShowAttractionCubit.getInstans()),
        BlocProvider.value(value: SearchCubit.getInstans()),
      ],
      child: BlocConsumer<ImageProccessingCubit, ImageProcessingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            // VideoPlayerController? _videoController;

            return Scaffold(
              appBar: myAppBar(),
              body: ConditionalBuilder(
                condition: state is! SearchSiteInDBLoadingState &&
                    state is! ImageProcessingLoadingState,
                builder: (context) {
                  // _videoController?.dispose();
                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.dg),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(width: 2),
                        ),
                        margin: EdgeInsets.all(15.dg),
                        width: double.infinity,
                        height: ScreenHeight(context) / 2.3,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                searchAttButton(
                                    context, SearchCubit.getInstans()),
                                searchRestButton(
                                    context, SearchCubit.getInstans()),
                              ],
                            ),
                            Row(),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenHeight(context) / 2.5,
                          right: 15.dg,
                          left: 15.dg,
                          bottom: 15.dg,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(width: 2),
                        ),
                        width: double.infinity,
                        height: ScreenHeight(context) / 2.3,
                        child: Container(
                          padding: EdgeInsets.all(5.dg),
                          child: Column(
                            children: [
                              Text(
                                "More Information",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.sp),
                              ),
                              SizedBox(height: ScreenHeight(context) / 40),
                              ConditionalBuilder(
                                condition:
                                    ImageProccessingCubit.getInstans().site !=
                                        null,
                                builder: (context) {
                                  return siteItem(
                                    context,
                                    site: ImageProccessingCubit.getInstans()
                                        .site!,
                                    cubit: ShowAttractionCubit.getInstans(),
                                  );
                                },
                                fallback: (context) {
                                  return Container(
                                    color: Colors.amber,
                                    child: Text("Not Found",
                                        style: TextStyle(fontSize: 20.sp)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                fallback: (context) => ConditionalBuilder(
                  condition: state is ImageProcessingLoadingState,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  },
                  fallback: (context) {
                    // _videoController = VideoPlayerController.asset(
                    //   'assets/videos/searchvideo.mp4',
                    // )..initialize().then((_) {
                    //     _videoController!.play();
                    //     _videoController!.setLooping(true);
                    //   });
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }

  Widget searchAttButton(context, SearchCubit searchCubit) {
    return InkWell(
      onTap: () {
        searchCubit.setAttraction(ShowSiteCubit.getInstans().acceptedSites);
        Navigator.pushNamed(context, SearchScreen.route);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        width: 125.w,
        child: Column(
          children: [
            Image.asset("assets/images/searchIcons.png", fit: BoxFit.cover),
            Text("nearby Attraction"),
          ],
        ),
      ),
    );
  }

  Widget searchRestButton(context, SearchCubit searchCubit) {
    return InkWell(
      onTap: () {
        searchCubit.getRestaurants();
        Navigator.pushNamed(context, SearchScreen.route);
      },
      child: Container(
        width: 125.w,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Image.asset("assets/images/restaurantIcon.png", fit: BoxFit.cover),
            Text("nearby Restaurant"),
          ],
        ),
      ),
    );
  }

  Widget siteItem(context,
      {required Site site, required ShowAttractionCubit cubit}) {
    return InkWell(
      onTap: () {
        cubit.setAttraction(site);
        Navigator.pushNamed(context, AttractionScreen.route);
      },
      child: Container(
        margin: EdgeInsets.only(right: 3.dg, left: 3.dg),
        height: ScreenHeight(context) / 3,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: MemoryImage(site.getImages().first!), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(),
        ),
        child: Text(""),
      ),
    );
  }

  Widget videoWidget(VideoPlayerController controller, context) {
    return Container(
      width: double.infinity,
      height: ScreenHeight(context) / 3,
      // color: Colors.amber,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
//Jordan Insider