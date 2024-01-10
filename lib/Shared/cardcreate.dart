import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Models/attraction.dart';
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
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: items.elementAt(index).getImages().isNotEmpty
                            ? Image.memory(
                                items.elementAt(index).getImages().first!,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(items.elementAt(index).getName())),
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
