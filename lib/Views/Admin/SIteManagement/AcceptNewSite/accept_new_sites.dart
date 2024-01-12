import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/AcceptSiteCubit/accept_site_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_state.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Admin/SIteManagement/AcceptSiteScreen/accept_site_screen.dart';

class AcceptNewSite extends StatelessWidget {
  const AcceptNewSite({super.key});
  static String route = "AcceptNewSite";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ShowSiteCubit.getInstans()),
        BlocProvider.value(value: AcceptSiteCubit.getInstans()),
      ],
      child: BlocConsumer<ShowSiteCubit, ShowSiteStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var siteCubit = ShowSiteCubit.getInstans();
            return Scaffold(
              appBar: myAppBar(),
              body: Container(
                margin: EdgeInsets.only(top: 5.dg),
                child: Column(
                  children: [
                    Text(
                      "Accept New Site",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              AcceptSiteCubit.getInstans()
                                  .setSiteToAcceptScreen(
                                      siteCubit.pendingSites[index]);
                              Navigator.pushNamed(
                                  context, AcceptSiteScreen.route);
                            },
                            child: ConditionalBuilder(
                              condition: index < siteCubit.pendingSites.length,
                              builder: (context) {
                                return formatNewSite(
                                    siteCubit.pendingSites[index],
                                    cubit: siteCubit);
                              },
                              fallback: null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget formatNewSite(Site pendingSite, {required ShowSiteCubit cubit}) {
    return Container(
      margin: EdgeInsets.all(10.dg),
      padding:
          EdgeInsets.only(top: 10.dg, bottom: 10.dg, left: 10.dg, right: 5.dg),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Row(
        children: [
          ConditionalBuilder(
              condition: cubit.siteCoorMap[pendingSite] != null &&
                  cubit.siteCoorMap[pendingSite]!.getImageU8L() != null,
              builder: (context) {
                return CircleAvatar(
                  radius: 20.sp,
                  backgroundImage: MemoryImage(
                      cubit.siteCoorMap[pendingSite]!.getImageU8L()!),
                );
              },
              fallback: (context) {
                return CircleAvatar(
                  radius: 20.sp,
                  backgroundImage:
                      AssetImage("assets/images/unknown-person.png"),
                );
              }),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pendingSite.getName().length < 20
                    ? pendingSite.getName()
                    : pendingSite.getName().substring(0, 20),
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              Text(cubit.siteCoorMap[pendingSite] != null
                  ? cubit.siteCoorMap[pendingSite]!.getFullName()
                  : "..."),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.dg),
                  alignment: Alignment.center,
                  child: Text(pendingSite.getDescription(),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
