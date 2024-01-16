// ignore_for_file: must_be_immutable
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/RestaurantCubit/restaurant_cubit.dart';
import 'package:jordan_insider/Controller/RestaurantCubit/restaurant_state.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';
import 'package:jordan_insider/utils/intent_utils/intent_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateCard extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);
  Set<Attraction> items;
  CreateCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ShowAttractionCubit.getInstans(),
      child: BlocConsumer<ShowAttractionCubit, ShowAttractionStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return SizedBox(
              height: ScreenHeight(context) / 5,
              child: PageView.builder(
                controller: _pageController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.dg),
                    child: InkWell(
                      onTap: () {
                        ShowAttractionCubit.getInstans()
                            .setAttraction(items.elementAt(index));
                        Navigator.pushNamed(context, AttractionScreen.route);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: items.elementAt(index).getImages().isNotEmpty
                                ? Image.memory(
                                    items.elementAt(index).getImages().first!,
                                    fit: BoxFit.cover,
                                  )
                                : Center(child: Container()),
                          ),
                          Container(
                            padding: EdgeInsets.all(7.5.dg),
                            alignment: Alignment.topCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  items.elementAt(index).getName().length < 20
                                      ? items.elementAt(index).getName()
                                      : "${items.elementAt(index).getName().substring(0, 20)}...",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      shadows: const [
                                        Shadow(
                                            blurRadius: 10,
                                            color: Colors.black,
                                            offset: Offset(3, 2)),
                                      ]),
                                ),
                                ConditionalBuilder(
                                  condition: items.elementAt(index) is Site,
                                  builder: (context) {
                                    return Row(
                                      children: [
                                        Text(
                                          (items.elementAt(index) as Site)
                                              .getAvgRate()
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                              shadows: const [
                                                Shadow(
                                                    blurRadius: 10,
                                                    color: Colors.black,
                                                    offset: Offset(3, 2)),
                                              ]),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          shadows: const [
                                            Shadow(
                                                blurRadius: 20,
                                                color: Colors.black,
                                                offset: Offset(2, 2)),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  fallback: null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onPageChanged: (index) {
                  // You can perform any actions here when the page is changed (e.g., update the UI)
                },
              ),
            );
          }),
    );
  }
}

enum SortRestaurantBy {
  name,
  rate,
  distance,
}

bool flag = true;

class CreateRestCard extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);

  SortRestaurantBy? sortBy;
  CreateRestCard({super.key, this.sortBy});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: RestaurantCubit.getInstans(),
      child: BlocConsumer<RestaurantCubit, RestaurantStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = RestaurantCubit.getInstans();
            flag ? cubit.getNearByRestaurants() : null;
            flag ? flag = false : null;

            return ConditionalBuilder(
              condition: state is! RestaurantLoadingState,
              builder: (context) {
                return FutureBuilder(
                    future: Permission.location.isGranted,
                    initialData: false,
                    builder: (context, snapshot) {
                      return ConditionalBuilder(
                        condition: snapshot.data ?? false,
                        builder: (context) => SizedBox(
                          height: ScreenHeight(context) / 5,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: cubit.nearByRestaurants.length,
                            itemBuilder: (context, index) {
                              sortSet();
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.dg),
                                child: InkWell(
                                  onTap: () {
                                    IntentUtils.launchGoogleMaps(
                                        lat: cubit.nearByRestaurants
                                            .elementAt(index)
                                            .getLocLat(),
                                        long: cubit.nearByRestaurants
                                            .elementAt(index)
                                            .getLocLng());
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: cubit.nearByRestaurants
                                                    .elementAt(index)
                                                    .getNetworkImage() ==
                                                ""
                                            ? Image.asset(
                                                "assets/images/restaurant.jpg",
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                cubit.nearByRestaurants
                                                    .elementAt(index)
                                                    .getNetworkImage(),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(7.5.dg),
                                        alignment: Alignment.topCenter,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        blurRadius: 15,
                                                        color: Colors.black,
                                                        offset: Offset(3, 2)),
                                                  ]),
                                              child: Text(
                                                cubit.nearByRestaurants
                                                            .elementAt(index)
                                                            .getName()
                                                            .length <
                                                        20
                                                    ? cubit.nearByRestaurants
                                                        .elementAt(index)
                                                        .getName()
                                                    : "${cubit.nearByRestaurants.elementAt(index).getName().substring(0, 20)}...",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp,
                                                    shadows: const [
                                                      Shadow(
                                                          blurRadius: 15,
                                                          color: Colors.black,
                                                          offset: Offset(3, 2)),
                                                    ]),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  (cubit.nearByRestaurants
                                                          .elementAt(index))
                                                      .getRate()
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.sp,
                                                      shadows: const [
                                                        Shadow(
                                                            blurRadius: 10,
                                                            color: Colors.black,
                                                            offset:
                                                                Offset(3, 2)),
                                                      ]),
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  shadows: const [
                                                    Shadow(
                                                        blurRadius: 20,
                                                        color: Colors.black,
                                                        offset: Offset(2, 2)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            onPageChanged: (index) {
                              // You can perform any actions here when the page is changed (e.g., update the UI)
                            },
                          ),
                        ),
                        fallback: (context) => SizedBox(
                          height: ScreenHeight(context) / 5,
                          child: InkWell(
                            onTap: () async {
                              cubit.getNearByRestaurants();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Center(
                                      child: Text(
                                          "You must enable the Location to use this Service")),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              fallback: (context) => SizedBox(
                height: ScreenHeight(context) / 5,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          }),
    );
  }

  void sortSet() {
    List<Restaurant> list =
        RestaurantCubit.getInstans().nearByRestaurants.toList();
    switch (sortBy) {
      case SortRestaurantBy.name:
        list.sort((a2, a1) => a2.getName().compareTo(a1.getName()));

        break;
      case SortRestaurantBy.rate:
        list.sort((a1, a2) => a2.getRate().compareTo(a1.getRate()));
        break;
      case SortRestaurantBy.distance:
      default:
    }
    RestaurantCubit.getInstans().nearByRestaurants.clear();
    RestaurantCubit.getInstans().nearByRestaurants.addAll(list.toSet());
  }
}
