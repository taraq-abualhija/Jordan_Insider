import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Models/tourist_user.dart';

import '../../../../Shared/Constants.dart';

// EditProfile
// ignore: must_be_immutable
bool firstTime = true;
var nameController = TextEditingController();
var phoneNoController = TextEditingController();
var emailController = TextEditingController();

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});
  static String route = "EditProfile";

  @override
  Widget build(BuildContext context) {
    var cubit = UserDataCubit.getInstans();
    if (firstTime) {
      nameController =
          TextEditingController(text: cubit.userData!.getFullName());
      try {
        phoneNoController = TextEditingController(
            text: (cubit.userData as Tourist).getPhoneNum());
      } catch (e) {
        e;
      }
      cubit.displayimage = cubit.userData!.getImageU8L();

      emailController = TextEditingController(text: cubit.userData!.getEmail());
      firstTime = false;
    }

    var formKey = GlobalKey<FormState>();

    return BlocProvider.value(
      value: UserDataCubit.getInstans(),
      child: BlocConsumer<UserDataCubit, UserDataStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UserDataCubit cubit = UserDataCubit.getInstans();

          Future pickImageFromGallery() async {
            try {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              cubit.changeImage(File(image!.path).readAsBytesSync());
            } catch (e) {
              logger.e("Error in _pickImageFromGallery $e");
            }
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: myAppBar(
              title: const Text("Profile"),
              elevation: 0,
            ),
            body: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      /*Image*/ Stack(
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
                            child: InkWell(
                              onTap: pickImageFromGallery,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 55,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 50,
                                  backgroundImage: cubit.displayimage != null
                                      ? MemoryImage(cubit.displayimage!)
                                      : AssetImage(
                                              "assets/images/unknown-person.png")
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenHeight(context) / 25),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.dg),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Email : ",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: DefaultFormField(
                                      enabled: false,
                                      controller: emailController,
                                      validate: (val) {
                                        return;
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenHeight(context) / 50),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Name : ",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: DefaultFormField(
                                      controller: nameController,
                                      validate: (val) {
                                        return;
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenHeight(context) / 50),
                            ConditionalBuilder(
                              condition: cubit.userData is Tourist,
                              builder: (context) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Phone # : ",
                                        style: TextStyle(fontSize: 15.sp),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: DefaultFormField(
                                          controller: phoneNoController,
                                          validate: (val) {
                                            return;
                                          }),
                                    ),
                                  ],
                                );
                              },
                              fallback: null,
                            ),
                            SizedBox(height: ScreenHeight(context) / 50),
                            DefaultButton(
                              text: "change password",
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ConditionalBuilder(
                    condition: state is! UserGetDataLoadingState,
                    builder: (context) {
                      return Container(
                        margin: EdgeInsets.all(20.dg),
                        child: DefaultButton(
                          text: "Save",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}