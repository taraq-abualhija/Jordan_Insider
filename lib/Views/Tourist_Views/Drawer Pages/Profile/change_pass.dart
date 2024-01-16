import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:motion_toast/motion_toast.dart';

var oldPassController = TextEditingController();
var newPassController = TextEditingController();
var new2PassController = TextEditingController();
var formKey = GlobalKey<FormState>();

class ChangePassScreen extends StatelessWidget {
  const ChangePassScreen({super.key});
  static String route = "ChangePassScreen";
  @override
  Widget build(BuildContext context) {
    RegExp passReg = RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$");

    return BlocProvider.value(
      value: UserDataCubit.getInstans(),
      child: BlocConsumer<UserDataCubit, UserDataStates>(
          listener: (context, state) async {
        if (state is UserChangePassSuccessState) {
          MotionToast.success(
                  toastDuration: Duration(milliseconds: 1400),
                  position: MotionToastPosition.top,
                  animationCurve: Curves.fastLinearToSlowEaseIn,
                  description: Text("Change Password Success"))
              .show(context);
          await Future.delayed(Duration(milliseconds: 1500));
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else if (state is UserChangePassErrorState) {
          MotionToast.warning(
                  toastDuration: Duration(milliseconds: 1500),
                  position: MotionToastPosition.top,
                  animationCurve: Curves.fastLinearToSlowEaseIn,
                  description: Text(
                      "Something went Wrong!\nYour password still the same"))
              .show(context);
        }
      }, builder: (context, state) {
        var cubit = UserDataCubit.getInstans();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: myAppBar(
            title: const Text("Change Password"),
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                            backgroundImage: cubit.userData!.getImageU8L() !=
                                    null
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
                    margin: EdgeInsets.symmetric(horizontal: 15.dg),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          DefaultFormField(
                            textInputAction: TextInputAction.next,
                            label: "Old Password",
                            controller: oldPassController,
                            validate: (val) {
                              if (val != "") {
                                return null;
                              }
                              return "Password can't by empty";
                            },
                          ),
                          SizedBox(height: ScreenHeight(context) / 30),
                          DefaultFormField(
                            textInputAction: TextInputAction.next,
                            label: "New Password",
                            controller: newPassController,
                            validate: (val) {
                              if (val == null) {
                                return "Password can't be empty";
                              } else if (!passReg.hasMatch(val)) {
                                return "Password must be contant Minimum eight characters\nat least one uppercase letter, one lowercase letter\nand one number:";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: ScreenHeight(context) / 30),
                          DefaultFormField(
                            label: "ReEnter Password",
                            controller: new2PassController,
                            validate: (val) {
                              if (val == "") {
                                return "Password can't by empty";
                              } else if (val != newPassController.text) {
                                return "Password must by the same!";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ConditionalBuilder(
                condition: state is! UserChangePassLoadingState,
                builder: (context) {
                  return Container(
                    margin: EdgeInsets.all(20.dg),
                    child: DefaultButton(
                      text: "Change",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (oldPassController.text !=
                              cubit.userData!.getPass()) {
                            MotionToast.warning(
                                    toastDuration: Duration(milliseconds: 1400),
                                    position: MotionToastPosition.top,
                                    animationCurve:
                                        Curves.fastLinearToSlowEaseIn,
                                    description: Text("Old Password is wrong"))
                                .show(context);
                          } else {
                            cubit.changePass(newPassController.text);
                          }
                        }
                      },
                    ),
                  );
                },
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        );
      }),
    );
  }
}
