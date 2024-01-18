// ignore: file_names
// ignore_for_file: constant_identifier_names, file_names, duplicate_ignore, non_constant_identifier_names
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Models/tourist_user.dart';
import 'package:jordan_insider/Views/Shared_Views/imageProcessing/camera_screen.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/Profile/profile.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/favorite.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/help.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/notification.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/tickets.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/user_reviews.dart';
import 'package:logger/logger.dart';

double ScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double ScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

Logger logger = Logger();

Color mainColor = Color.fromARGB(255, 56, 94, 206);
HexColor textColor = HexColor('#4F4F4F');
//264190
PreferredSizeWidget myAppBar({
  Widget? leading,
  List<Widget>? actions,
  Widget? title,
  double? elevation = 4,
}) {
  title ??= Image(image: AssetImage("assets/images/logo.png"), height: 30.h);
  return AppBar(
    centerTitle: true,
    flexibleSpace: Container(
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
    ),
    leading: leading,
    title: title,
    actions: actions,
    elevation: elevation,
  );
}

Widget DefaultFormField({
  required TextEditingController controller,
  TextInputType inputType = TextInputType.name,
  required String? Function(String?)? validate,
  Function()? OnTap,
  Function(String)? onChanged,
  Function(String)? onFieldSubmitted,
  String? label,
  Widget? prefixIcon,
  var hintText,
  TextStyle? hintStyle,
  int? maxLength,
  int? maxLines,
  TextInputAction? textInputAction,
  Widget? suffixIcon,
  bool? enabled,
  bool showCursor = true,
  AutovalidateMode autovalidate = AutovalidateMode.disabled,
  double width = double.infinity,
  double? height,
  bool isObscureText = false,
  Color prefixIconColor = Colors.black,
  Color suffixIconColor = Colors.black,

  // Color textColor = Colors.black,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        maxLines: maxLines,
        textInputAction: textInputAction,
        maxLength: maxLength,
        enabled: enabled,
        onFieldSubmitted: onFieldSubmitted,
        autovalidateMode: autovalidate,
        onChanged: onChanged,
        onTap: OnTap,
        obscureText: isObscureText,
        controller: controller,
        keyboardType: inputType,
        validator: validate,
        showCursor: showCursor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          prefixIcon: prefixIcon,
          // enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
          // focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
          counterText: "",
          hintStyle: hintStyle,
          hintText: hintText,
          labelText: label,

          prefixIconColor: prefixIconColor,
          suffixIconColor: suffixIconColor,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
      ),
    );

Widget DefaultButton(
    {required String text,
    Function()? onPressed,
    Color textcolor = Colors.white,
    double width = double.infinity,
    double? height,
    TextStyle? style,
    Color? color,
    ShapeBorder? shape,
    Color? gradientColor1,
    Color? gradientColor2,
    Icon? icon}) {
  gradientColor1 ??= Color.fromARGB(255, 40, 110, 200);
  gradientColor2 ??= Color.fromARGB(255, 40, 65, 150);
  height ??= 50.h;
  shape ??= RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: color,
      gradient: color == null
          ? LinearGradient(
              colors: [
                gradientColor1,
                gradientColor2,
              ],
              begin: const FractionalOffset(1, 1.0), // 1 1 |
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
          : null,
    ),
    child: MaterialButton(
      disabledColor: Colors.grey,
      shape: shape,
      minWidth: width,
      height: height,
      // color: color,
      onPressed: onPressed,
      child: ConditionalBuilder(
        condition: icon == null,
        builder: (context) {
          return Text(
            text,
            style: style ?? TextStyle(color: textcolor, fontSize: 20.sp),
          );
        },
        fallback: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: style ?? TextStyle(color: textcolor, fontSize: 20.sp),
              ),
              SizedBox(width: ScreenWidth(context) / 25),
              icon!,
            ],
          );
        },
      ),
    ),
  );
}

Widget DefaultDrawer() {
  return BlocProvider.value(
    value: UserDataCubit.getInstans(),
    child: BlocConsumer<UserDataCubit, UserDataStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userData = UserDataCubit.getInstans().userData;

          Widget TouristMenu() {
            return Column(
              children: [
                /*Reviews*/ ListTile(
                  title: Text("Reviews"),
                  leading: Icon(Icons.star),
                  onTap: () {
                    Navigator.pushNamed(context, UserReviews.route);
                  },
                ),
                /*Favorite*/ ListTile(
                  title: Text("Favorite"),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.pushNamed(context, Favorite.route);
                  },
                ),
                /*Tickets*/ ListTile(
                  title: Text("Tickets"),
                  leading: Icon(Icons.local_activity),
                  onTap: () {
                    Navigator.pushNamed(context, Tickets.route);
                  },
                ),
              ],
            );
          }

          return Drawer(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/cover.jpg"),
                            fit: BoxFit.cover),
                      ),
                      child: Text(""),
                    ),
                    /*User Image,Email,Name */ Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Column(
                        children: [
                          ConditionalBuilder(
                            condition: userData?.getImageU8L() != null,
                            builder: (context) => CircleAvatar(
                              radius: 40.r,
                              backgroundImage:
                                  MemoryImage(userData!.getImageU8L()!),
                            ),
                            fallback: (context) => CircleAvatar(
                              radius: 40.r,
                              backgroundImage: AssetImage(
                                  "assets/images/unknown-person.png"),
                            ),
                          ),
                          Text(
                            userData?.getEmail() ?? "",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(userData?.getFullName() ?? "User name"),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              /*Home*/ ListTile(
                                title: Text("Home page"),
                                leading: Icon(Icons.home),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              /*Profile*/ ListTile(
                                title: Text("Profile"),
                                leading: Icon(Icons.person),
                                onTap: () {
                                  Navigator.pushNamed(context, Profile.route);
                                },
                              ),
                              /*Noti*/ ListTile(
                                title: Text("Notification"),
                                leading: Icon(Icons.notifications),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppNotification.route);
                                },
                              ),
                              /*For Tourist*/ userData is Tourist
                                  ? TouristMenu()
                                  : Container(),
                              /*Camera*/ ListTile(
                                title: Text("Camera Processing"),
                                leading: Icon(Icons.camera_enhance_rounded),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CameraScreen.route);
                                },
                              ),
                              /*Help*/ ListTile(
                                title: Text("Help"),
                                leading: Icon(Icons.help),
                                onTap: () {
                                  Navigator.pushNamed(context, Help.route);
                                },
                              ),
                              /*LogOut*/ ListTile(
                                title: Text("Log out"),
                                leading: Icon(Icons.logout),
                                onTap: () {
                                  userLogOut(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12.dg),
                        child: Text(
                          "Developed by JUST team © 2024",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
  );
}
