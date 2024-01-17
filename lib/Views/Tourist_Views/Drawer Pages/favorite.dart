// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Models/tourist_user.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/welcomepage.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});
  static String route = "Favorite";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: UserDataCubit.getInstans()),
        BlocProvider.value(value: ShowSiteCubit.getInstans()),
        BlocProvider.value(value: ShowAttractionCubit.getInstans()),
      ],
      child: BlocConsumer<UserDataCubit, UserDataStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var userFavorite = (UserDataCubit.getInstans().userData as Tourist)
                .getUserFavorite();
            List<Site> favoriteSites = [];

            for (var id in userFavorite) {
              favoriteSites.add(ShowSiteCubit.getInstans()
                  .acceptedSites
                  .where((element) => element.getID() == id)
                  .first);
            }

            return Scaffold(
              appBar: myAppBar(
                title: Text("Favorite"),
              ),
              body: ConditionalBuilder(
                condition:
                    UserDataCubit.getInstans().userData!.getEmail().isNotEmpty,
                builder: (context) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: userFavorite.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        ShowAttractionCubit.getInstans()
                            .setAttraction(favoriteSites.elementAt(index));
                        Navigator.pushReplacementNamed(
                            context, AttractionScreen.route);
                      },
                      child: Container(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.all(5.dg),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(favoriteSites
                                .elementAt(index)
                                .getImages()
                                .first!),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            UserDataCubit.getInstans().removeFromFav(
                                favoriteSites.elementAt(index).getID());
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.favorite, size: 35.sp),
                              Icon(Icons.favorite,
                                  color: Colors.red, size: 30.sp),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                fallback: (context) => Center(
                    child: Container(
                  margin: EdgeInsets.all(20.dg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login to see your Favorite",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      DefaultButton(
                        text: "Go to Login ->",
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, WelcomePage.route, (route) => false);
                        },
                      )
                    ],
                  ),
                )),
              ),
            );
          }),
    );
  }
}
