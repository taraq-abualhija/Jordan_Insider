import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';

// ignore: must_be_immutable
class CreateCard extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);
  Set<Attraction> items;
  CreateCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowAttractionCubit(),
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
                                  items.elementAt(index).getName(),
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
