import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_cubit.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_state.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/showEventCubit/show_event_cubit.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static String route = "SearchScreen";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ShowAttractionCubit()),
        BlocProvider(create: (context) => ShowSiteCubit()),
        BlocProvider(create: (context) => ShowEventCubit()),
        BlocProvider(create: (context) => SearchCubit()),
      ],
      child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var attCubit = ShowAttractionCubit.getInstans();
            var searchCubit = SearchCubit.getInstans();
            print(searchCubit.getAttractions().length);
            return Scaffold(
              appBar: AppBarWithSearchSwitch(
                onChanged: (text) {
                  print(text);
                },
                onSubmitted: (text) {
                  print(text);
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
                              image: "assets/images/events.png",
                              name: "Events",
                            ),
                          ),
                        ),
                        searchCat(
                          image: "assets/images/restaurant.png",
                          name: "Restaurant",
                        ),
                      ],
                    ),
                    SizedBox(height: 10.dg),
                    Expanded(
                      child: GridView.extent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 3,
                        mainAxisSpacing: 10.dg,
                        children: searchCubit.getAttractions().isNotEmpty
                            ? searchCubit.getAttractions().map((item) {
                                return searchItem(context,
                                    attraction: item, cubit: attCubit);
                              }).toList()
                            : [],
                      ),
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
}
