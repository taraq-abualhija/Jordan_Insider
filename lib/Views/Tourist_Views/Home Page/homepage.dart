import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/showEventCubit/show_event_cubit.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Tourist_Views/Search_Screen/searchscreen.dart';

import '../../../Shared/cardcreate.dart';

bool getSites = true;
final Set<Site> bestPlaces = {};
final Set<SiteEvent> nextEvents = {};
final Set<Restaurant> nearbyRestaurants = {};

class TouristHomePage extends StatelessWidget {
  TouristHomePage({super.key});
  static String route = "TouristHomePage";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ShowSiteCubit.getInstans()),
        BlocProvider.value(value: UserDataCubit.getInstans()),
        BlocProvider.value(value: ShowEventCubit.getInstans()),
      ],
      child: BlocConsumer<ShowSiteCubit, ShowSiteStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShowSiteCubit.getInstans();
          var eventCubit = ShowEventCubit.getInstans();
          if (getSites) {
            getSites = false;
            cubit.getAllSites();
            eventCubit.getAllEvents();
            cubit.justEmitInit();
          }
          if (state is GetSiteSuccessStates) {
            bestPlaces.clear();
            nextEvents.clear();
            getBestPlaces(cubit.acceptedSites);
            getBestEvents(eventCubit.events);
            cubit.justEmitInit();
          }

          return Scaffold(
            key: _scaffoldKey,
            drawer: DefaultDrawer(),
            appBar: myAppBar(
                leading: IconButton(
                    onPressed: () {
                      cubit.justEmitInit();
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(Icons.menu)),
                actions: [
                  IconButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, SearchScreen.route);
                    },
                    icon: Icon(Icons.search),
                  ),
                ]),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.all(10.dg),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 30,
                              ),
                              Text(
                                "Best places",
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ],
                          ),
                          CreateCard(items: bestPlaces)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.all(10.dg),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 30,
                              ),
                              Text(
                                "Week Events",
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ],
                          ),
                          CreateCard(items: nextEvents)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.all(10.dg),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                                  Text(
                                    "Nearby Restaurants",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ],
                              ),
                              DropdownButton<String>(
                                value: cubit.dropdownValue.name,
                                items: <String>[
                                  SortRestaurantBy.distance.name,
                                  SortRestaurantBy.rate.name,
                                  SortRestaurantBy.name.name,
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  cubit.changeDropdownValue(value);
                                },
                              )
                            ],
                          ),
                          CreateRestCard(
                            sortBy: cubit.dropdownValue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void getBestPlaces(List<Site> sites) {
    Site bestSite = sites.first;
    while (bestPlaces.contains(bestSite)) {
      var rand = Random().nextInt(sites.length);
      bestSite = sites[rand];
    }
    for (var element in sites) {
      if (!bestPlaces.contains(element)) {
        if (element.getAvgRate() > bestSite.getAvgRate()) {
          bestSite = element;
        }
      }
    }
    bestPlaces.add(bestSite);
    if (bestPlaces.length < 5) {
      //1 2 3 4 5
      if (bestPlaces.length == sites.length) {
        // 0 //3
        return;
      }
      getBestPlaces(sites);
    }
  }

  void getBestEvents(List<SiteEvent> events) {
    for (var element in events) {
      if (!nextEvents.contains(element)) {
        try {
          int day = int.parse(element
              .getStartDate()
              .substring(0, element.getStartDate().indexOf("-"))); //day

          int month = int.parse(element.getStartDate().substring(
              element.getStartDate().indexOf('-') + 1,
              element.getStartDate().lastIndexOf('-'))); //month

          int year = int.parse(element
              .getStartDate()
              .substring(element.getStartDate().lastIndexOf('-') + 1)); //year

          DateTime eleDate = DateTime(year, month, day);

          if (eleDate.difference(DateTime.now()).inDays < 6) {
            nextEvents.add(element);
          }
        } catch (e) {
          logger.e(e);
        }
      }
    }
  }
}
