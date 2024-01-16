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
import 'package:jordan_insider/Views/Coordinator_Views/AddSite/addsitepage.dart';
import 'package:jordan_insider/Views/Coordinator_Views/AddEventScreen/addeventscreen.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';

bool getFirstTime = true;

class CoorHomePage extends StatelessWidget {
  CoorHomePage({super.key});
  static String route = "CoorHomePage";
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
          var userDataCubit = UserDataCubit.getInstans();

          if (userDataCubit.userData == null) {
            return Scaffold(
              appBar: myAppBar(),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (getFirstTime) {
            siteCubit.getAllSites(id: userDataCubit.userData!.getId());
            eventCubit.getAllEvents(id: userDataCubit.userData!.getId());
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DefaultButton(
                          text: "+ New Site",
                          onPressed: () {
                            Navigator.pushNamed(context, AddSitePage.route);
                          },
                          height: 40.h,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(width: ScreenWidth(context) / 25),
                      Expanded(
                        child: DefaultButton(
                          text: "+ New Event",
                          onPressed: () {
                            Navigator.pushNamed(context, AddEventScreen.route);
                          },
                          height: 40.h,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenHeight(context) / 100),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: viewSitesorEvents.length,
                      itemBuilder: (context, index) {
                        return viewSitesorEvents.elementAt(index);
                      },
                      onPageChanged: (index) {
                        // You can perform any actions here when the page is changed (e.g., update the UI)
                      },
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
        cubit.getAllSites(id: UserDataCubit.getInstans().userData!.getId());

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
                    style: TextStyle(fontSize: 15.sp, color: Colors.black45),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenHeight(context) / 100),
          ConditionalBuilder(
            condition: cubit.coorSite.isNotEmpty,
            builder: (context) {
              return Expanded(
                child: ListView.builder(
                  reverse: false,
                  itemCount: cubit.coorSite.length,
                  itemBuilder: (context, index) {
                    return ConditionalBuilder(
                      condition: index < cubit.coorSite.length,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(5.dg),
                          margin: EdgeInsets.only(bottom: 10.dg),
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cubit.coorSite[index].getName().length < 20
                                        ? cubit.coorSite[index].getName()
                                        : "${cubit.coorSite[index].getName().substring(0, 20)}...",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    cubit.coorSite[index].getStatus(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            cubit.coorSite[index].getStatus() ==
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
                                            child: Text("Edit"),
                                            onTap: () {
                                              cubit.editSiteIndex = index;

                                              Navigator.pushNamed(
                                                  context, AddSitePage.route);
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Text("Delete"),
                                            onTap: () {
                                              _showConfirmationDialog(context,
                                                  cubit.coorSite[index], cubit);
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Text("Show"),
                                            onTap: () {
                                              ShowAttractionCubit.getInstans()
                                                  .setAttraction(
                                                      cubit.coorSite[index]);

                                              Navigator.pushNamed(context,
                                                  AttractionScreen.route);
                                            },
                                          ),
                                        ],
                                        position: RelativeRect.fromLTRB(
                                            (position.globalPosition.dx -
                                                100.w),
                                            position.globalPosition.dy,
                                            25.w,
                                            0),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Icon(
                                        Icons.more_horiz,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                cubit.coorSite[index].getDescription() != ""
                                    ? cubit.coorSite[index].getDescription()
                                    : "No Description",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      cubit.coorSite[index].getDescription() ==
                                              ""
                                          ? Colors.red
                                          : null,
                                ),
                              ),
                              SizedBox(
                                height: 250.h,
                                width: ScreenWidth(context),
                                child: ConditionalBuilder(
                                  condition: cubit.coorSite[index]
                                      .getImages()
                                      .isNotEmpty,
                                  builder: (context) {
                                    return Image.memory(
                                      cubit.coorSite[index].getImages().first!,
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
              );
            },
            fallback: (context) => Container(
              height: ScreenHeight(context) / 2,
              width: double.infinity,
              alignment: Alignment.topCenter,
              child: Text(
                "You Have No Sites",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        cubit.getAllEvents(id: UserDataCubit.getInstans().userData!.getId());

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
                  style: TextStyle(fontSize: 15.sp, color: Colors.black45),
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
          ConditionalBuilder(
            condition: cubit.coorEvents.isNotEmpty,
            builder: (context) {
              return Expanded(
                child: ListView.builder(
                  reverse: false,
                  itemCount: cubit.coorEvents.length,
                  itemBuilder: (context, index) {
                    return ConditionalBuilder(
                      condition: index < cubit.coorEvents.length,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(5.dg),
                          margin: EdgeInsets.only(bottom: 10.dg),
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cubit.coorEvents[index].getName(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTapDown: (position) {
                                      showMenu(
                                        context: context,
                                        items: [
                                          PopupMenuItem(
                                            child: Text("Edit"),
                                            onTap: () {
                                              cubit.editEventIndex = index;

                                              Navigator.pushNamed(context,
                                                  AddEventScreen.route);
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Text("Delete"),
                                            onTap: () {
                                              _showConfirmationDialog(
                                                  context,
                                                  cubit.coorEvents[index],
                                                  cubit);
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Text("Show"),
                                            onTap: () {
                                              ShowAttractionCubit.getInstans()
                                                  .setAttraction(
                                                      cubit.coorEvents[index]);
                                              Navigator.pushNamed(context,
                                                  AttractionScreen.route);
                                            },
                                          ),
                                        ],
                                        position: RelativeRect.fromLTRB(
                                            (position.globalPosition.dx -
                                                100.w),
                                            position.globalPosition.dy,
                                            25.w,
                                            0),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Icon(
                                        Icons.more_horiz,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                cubit.coorEvents[index].getDescription() != ""
                                    ? cubit.coorEvents[index].getDescription()
                                    : "No Description",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: cubit.coorEvents[index]
                                              .getDescription() ==
                                          ""
                                      ? Colors.red
                                      : null,
                                ),
                              ),
                              SizedBox(
                                height: 250.h,
                                width: ScreenWidth(context),
                                child: ConditionalBuilder(
                                  condition: cubit.coorEvents[index]
                                      .getImages()
                                      .isNotEmpty,
                                  builder: (context) {
                                    return Image.memory(
                                      cubit.coorEvents[index]
                                          .getImages()
                                          .first!,
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
              );
            },
            fallback: (context) => Container(
              height: ScreenHeight(context) / 2,
              width: double.infinity,
              alignment: Alignment.topCenter,
              child: Text(
                "You Have No Events",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                'Are you sure you want to Delete ${attraction.getName()}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  cubit.deleteSite(attraction.getID());
                  Navigator.of(context).pop();
                  if (attraction is Site) {
                    ShowSiteCubit.getInstans().coorSite.remove(attraction);
                  } else {
                    ShowEventCubit.getInstans().coorEvents.remove(attraction);
                  }
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
