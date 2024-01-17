import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Models/admin_user.dart';
import 'package:jordan_insider/Models/coordinator_user.dart';
import 'package:jordan_insider/Models/tourist_user.dart';

import '../../../../Shared/Constants.dart';
import 'EditProfile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  static String route = "Profile";
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: UserDataCubit.getInstans(),
      child: BlocConsumer<UserDataCubit, UserDataStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UserDataCubit cubit = UserDataCubit.getInstans();
          return Scaffold(
            appBar: myAppBar(
              title: const Text("Profile"),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditProfile.route);
                    },
                    icon: const Icon(
                      Icons.edit,
                    )),
                IconButton(
                    onPressed: () {
                      cubit.changeTheme();
                    },
                    icon: Icon(cubit.themeIcon))
              ],
              elevation: 0,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: const [
                            Color.fromARGB(255, 21, 122, 204),
                            Color.fromARGB(255, 41, 54, 133),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      width: double.infinity,
                      height: 75,
                      child: const Text(""),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 55,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          backgroundImage: cubit.userData!.getImageU8L() != null
                              ? MemoryImage(cubit.userData!.getImageU8L()!)
                              : AssetImage("assets/images/unknown-person.png")
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenHeight(context) / 30),
                Container(
                  margin: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formatText("Name", cubit.userData!.getFullName()),
                      SizedBox(height: ScreenHeight(context) / 30),
                      formatText("Email", cubit.userData!.getEmail()),
                      SizedBox(height: ScreenHeight(context) / 30),
                      ConditionalBuilder(
                        condition: cubit.userData is! Admin,
                        builder: (context) => cubit.userData is Tourist
                            ? formatText("Phone #",
                                (cubit.userData as Tourist).getPhoneNum())
                            : formatText("Phone #",
                                (cubit.userData as Coordinator).getPhoneNum()),
                        fallback: null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget formatText(String type, String txt) => Text(
      "$type : $txt",
      style: TextStyle(fontSize: 20.sp),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
