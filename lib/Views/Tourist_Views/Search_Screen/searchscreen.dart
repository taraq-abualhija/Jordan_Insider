import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/RestaurantCubit/restaurant_cubit.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_cubit.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_state.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/showEventCubit/show_event_cubit.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';
import 'package:jordan_insider/utils/intent_utils/intent_utils.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static String route = "SearchScreen";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ShowAttractionCubit.getInstans()),
        BlocProvider.value(value: ShowSiteCubit.getInstans()),
        BlocProvider.value(value: ShowEventCubit.getInstans()),
        BlocProvider.value(value: SearchCubit.getInstans()),
        BlocProvider.value(value: RestaurantCubit.getInstans()),
      ],
      child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var attCubit = ShowAttractionCubit.getInstans();
            var searchCubit = SearchCubit.getInstans();
            return Scaffold(
              appBar: AppBarWithSearchSwitch(
                keepAppBarColors: false,
                onChanged: (text) {
                  // searchCubit.searchSites(text);
                },
                onSubmitted: (text) {
                  searchCubit.searchSites(text);
                },
                appBarBuilder: (context) {
                  return myAppBar(actions: [
                    AppBarSearchButton(),
                  ]);
                },
              ),
              body: Container(
                margin: EdgeInsets.all(15.dg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              searchCubit.setAttraction(
                                  ShowSiteCubit.getInstans().acceptedSites);
                            },
                            child: searchCat(
                              image: "assets/images/touristsites.png",
                              name: "Tourist Site",
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              searchCubit.setAttraction(
                                  ShowEventCubit.getInstans().events);
                            },
                            child: searchCat(
                              assetImage: Image.asset(
                                !!UserDataCubit.getInstans().isDark
                                    ? "assets/images/eventswhite.png"
                                    : "assets/images/events.png",
                              ),
                              name: "Events",
                              image: '',
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              searchCubit.getRestaurants();
                            },
                            child: searchCat(
                              image: "assets/images/restaurant.png",
                              name: "Restaurant",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.dg),
                    ConditionalBuilder(
                      condition: searchCubit.getAttractions().isNotEmpty ||
                          searchCubit.restaurant.isNotEmpty,
                      builder: (context) {
                        return ConditionalBuilder(
                          condition: state is SearchSuccessStates,
                          builder: (context) {
                            return Expanded(
                              child: GridView.extent(
                                maxCrossAxisExtent:
                                    MediaQuery.of(context).size.width / 2,
                                mainAxisSpacing: 10.dg,
                                children: searchCubit
                                        .getAttractions()
                                        .isNotEmpty
                                    ? searchCubit.getAttractions().map((item) {
                                        return searchItem(context,
                                            attraction: item, cubit: attCubit);
                                      }).toList()
                                    : searchCubit.restaurant.isNotEmpty
                                        ? searchCubit.restaurant.map((item) {
                                            return searchRestaurantItem(context,
                                                restaurant: item);
                                          }).toList()
                                        : [],
                              ),
                            );
                          },
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        );
                      },
                      fallback: null,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget searchCat({
    required String image,
    required String name,
    Widget? assetImage,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.dg),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
              ),
              height: 125.h,
              child: assetImage ??
                  Image.asset(
                    image,
                    fit: BoxFit.fitHeight,
                  ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.dg),
              child: Text(
                name,
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchItem(context,
      {required Attraction attraction, required ShowAttractionCubit cubit}) {
    return InkWell(
      onTap: () {
        cubit.setAttraction(attraction);
        Navigator.pushNamed(context, AttractionScreen.route);
      },
      child: Container(
        margin: EdgeInsets.only(right: 3.dg, left: 3.dg),
        height: 125.h,
        width: 125.w,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: MemoryImage(attraction.getImages().first!),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(),
        ),
        child: Text(""),
      ),
    );
  }

  Widget searchRestaurantItem(context, {required Restaurant restaurant}) {
    return InkWell(
      onTap: () {
        IntentUtils.launchGoogleMaps(
          lat: restaurant.getLocLat(),
          long: restaurant.getLocLng(),
        );
      },
      child: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(right: 3.dg, left: 3.dg),
        height: 125.h,
        width: 125.w,
        decoration: BoxDecoration(
          image: restaurant.getNetworkImage() == ""
              ? DecorationImage(
                  image: AssetImage("assets/images/restaurant.jpg"),
                  fit: BoxFit.fill)
              : DecorationImage(
                  image: NetworkImage(restaurant.getNetworkImage()),
                  fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(),
        ),
        child: Text(
          restaurant.getName(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
              shadows: const [
                Shadow(
                    blurRadius: 15, color: Colors.black, offset: Offset(3, 2)),
              ]),
        ),
      ),
    );
  }
}
