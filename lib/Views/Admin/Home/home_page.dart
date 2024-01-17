import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/showEventCubit/show_event_cubit.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Admin/AddCoor/add_coor_screen.dart';
import 'package:jordan_insider/Views/Admin/SIteManagement/AcceptNewSite/accept_new_sites.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';

bool getFirstTime = true;

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});
  static String route = "AdminHomePage";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ShowSiteCubit.getInstans()),
        BlocProvider.value(value: ShowEventCubit.getInstans()),
        BlocProvider.value(value: UserDataCubit.getInstans()),
        BlocProvider.value(value: ShowAttractionCubit.getInstans()),
      ],
      child: BlocConsumer<ShowSiteCubit, ShowSiteStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var siteCubit = ShowSiteCubit.getInstans();
          var eventCubit = ShowEventCubit.getInstans();

          if (getFirstTime) {
            siteCubit.getAllSites();
            eventCubit.getAllEvents();
            getFirstTime = false;
          }

          Set<Widget> viewSitesorEvents = {
            displaySites(context, siteCubit),
            displayEvents(context, eventCubit, siteCubit)
          };

          return Scaffold(
            key: _scaffoldKey,
            appBar: myAppBar(
              leading: IconButton(
                  onPressed: () {
                    siteCubit.justEmitInit();
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: Icon(Icons.menu)),
            ),
            drawer: DefaultDrawer(),
            body: Container(
              margin: EdgeInsets.all(10.dg),
              child: Column(
                children: [
                  DefaultButton(
                    text: 'Add New Coordinator',
                    onPressed: () {
                      Navigator.pushNamed(context, AddCoordinatorScreen.route);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(height: ScreenHeight(context) / 60),
                  DefaultButton(
                    text: "${siteCubit.pendingSites.length} New Sites",
                    onPressed: () {
                      Navigator.pushNamed(context, AcceptNewSite.route);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(height: ScreenHeight(context) / 100),
                  //#List of all Sites
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: viewSitesorEvents.length,
                      itemBuilder: (context, index) {
                        return viewSitesorEvents.elementAt(index);
                      },
                      onPageChanged: (index) {},
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget displaySites(BuildContext context, ShowSiteCubit cubit) {
    return RefreshIndicator(
      color: mainColor,
      displacement: 10,
      onRefresh: () async {
        cubit.getAllSites();

        await Future.delayed(Duration(seconds: 2));
        cubit.justEmitInit();
        return Future.delayed(Duration(seconds: 0));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(""),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Site",
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Events ->",
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenHeight(context) / 100),
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: cubit.allSites.length,
              itemBuilder: (context, index) {
                return ConditionalBuilder(
                  condition: index < cubit.allSites.length,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(5.dg),
                      margin: EdgeInsets.only(bottom: 10.dg),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: UserDataCubit.getInstans().isDark
                            ? Colors.white
                            : Colors.black,
                      )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cubit.allSites[index].getName().length < 20
                                    ? cubit.allSites[index].getName()
                                    : "${cubit.allSites[index].getName().substring(0, 20)}...",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                cubit.allSites[index].getStatus(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cubit.allSites[index].getStatus() ==
                                            "Accepted"
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 219, 22, 8)),
                              ),
                              GestureDetector(
                                onTapDown: (position) {
                                  showMenu(
                                    context: context,
                                    items: [
                                      PopupMenuItem(
                                        child: Text("Delete"),
                                        onTap: () {
                                          _showConfirmationDialog(context,
                                              cubit.allSites[index], cubit);
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: Text("Show"),
                                        onTap: () {
                                          ShowAttractionCubit.getInstans()
                                              .setAttraction(
                                                  cubit.allSites[index]);
                                          Navigator.pushNamed(
                                              context, AttractionScreen.route);
                                        },
                                      ),
                                    ],
                                    position: RelativeRect.fromLTRB(
                                        (position.globalPosition.dx - 100.w),
                                        position.globalPosition.dy,
                                        25.w,
                                        0),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Icon(
                                    Icons.more_horiz,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            cubit.allSites[index].getDescription() != ""
                                ? cubit.allSites[index].getDescription()
                                : "No Description",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  cubit.allSites[index].getDescription() == ""
                                      ? Colors.red
                                      : null,
                            ),
                          ),
                          SizedBox(
                            height: 250.h,
                            width: ScreenWidth(context),
                            child: ConditionalBuilder(
                              condition:
                                  cubit.allSites[index].getImages().isNotEmpty,
                              builder: (context) {
                                return Image.memory(
                                  cubit.allSites[index].getImages().first!,
                                  fit: BoxFit.fill,
                                );
                              },
                              fallback: (context) {
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  fallback: null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget displayEvents(
      BuildContext context, ShowEventCubit cubit, ShowSiteCubit siteCubit) {
    return RefreshIndicator(
      color: mainColor,
      displacement: 10,
      onRefresh: () async {
        cubit.getAllEvents();

        await Future.delayed(Duration(seconds: 2));
        siteCubit.justEmitInit();
        return Future.delayed(Duration(seconds: 0));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "<- Sites",
                  style: TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Events",
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ),
              Expanded(child: Text("")),
            ],
          ),
          SizedBox(height: ScreenHeight(context) / 100),
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: cubit.events.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(5.dg),
                  margin: EdgeInsets.only(bottom: 10.dg),
                  decoration: BoxDecoration(
                      border: Border.all(
                    width: 1,
                    color: UserDataCubit.getInstans().isDark
                        ? Colors.white
                        : Colors.black,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cubit.events[index].getName(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTapDown: (position) {
                              showMenu(
                                context: context,
                                items: [
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    onTap: () {
                                      _showConfirmationDialog(
                                          context, cubit.events[index], cubit);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text("Show"),
                                    onTap: () {
                                      ShowAttractionCubit.getInstans()
                                          .setAttraction(cubit.events[index]);

                                      Navigator.pushNamed(
                                          context, AttractionScreen.route);
                                    },
                                  ),
                                ],
                                position: RelativeRect.fromLTRB(
                                    (position.globalPosition.dx - 100.w),
                                    position.globalPosition.dy,
                                    25.w,
                                    0),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25)),
                              child: Icon(
                                Icons.more_horiz,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        cubit.events[index].getDescription() != ""
                            ? cubit.events[index].getDescription()
                            : "No Description",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cubit.events[index].getDescription() == ""
                              ? Colors.red
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 250.h,
                        width: ScreenWidth(context),
                        child: ConditionalBuilder(
                          condition: cubit.events[index].getImages().isNotEmpty,
                          builder: (context) {
                            return Image.memory(
                              cubit.events[index].getImages().first!,
                              fit: BoxFit.fill,
                            );
                          },
                          fallback: (context) {
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, Attraction attraction, cubit) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text(
                'Are you sure you want to Delete ${attraction.getName()} ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  cubit.deleteSite(attraction.getID());
                  if (attraction is Site) {
                    ShowSiteCubit.getInstans().allSites.remove(attraction);
                    ShowSiteCubit.getInstans().acceptedSites.remove(attraction);
                    ShowSiteCubit.getInstans().pendingSites.remove(attraction);
                  } else {
                    ShowEventCubit.getInstans().events.remove(attraction);
                  }
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
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }
}
