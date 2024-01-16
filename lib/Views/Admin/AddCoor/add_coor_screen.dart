import 'dart:math';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/LoginCubit/login_cubit.dart';
import 'package:jordan_insider/Controller/LoginCubit/login_state.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:motion_toast/motion_toast.dart';

var emailController = TextEditingController();
var passController = TextEditingController();
var phoneController = TextEditingController();
RegExp emailReg = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
var formKey = GlobalKey<FormState>();

class AddCoordinatorScreen extends StatelessWidget {
  const AddCoordinatorScreen({super.key});
  static String route = "AddCoordinatorScreen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: LoginCubit.getInstans(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            MotionToast.warning(
              description: Text("Something went wrong!"),
              position: MotionToastPosition.top,
            ).show(context);
          } else if (state is CreateCoordinatorErrorState) {
            MotionToast.warning(
              title: Text("Sorry"),
              description: Text(state.error),
              position: MotionToastPosition.top,
            ).show(context);
            emailController.clear();
            passController.clear();
            phoneController.clear();
          } else if (state is CreateCoordinatorSuccessState) {
            MotionToast.success(
              title: Text("Done"),
              description: Text("Add Coordinator Successfully"),
              position: MotionToastPosition.top,
            ).show(context);
            emailController.clear();
            passController.clear();
            phoneController.clear();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: myAppBar(),
            body: Container(
              margin: EdgeInsets.all(10.dg),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        DefaultFormField(
                          inputType: TextInputType.emailAddress,
                          hintText: "Email",
                          controller: emailController,
                          validate: (val) {
                            if (val == "" || val == null) {
                              return "Email can't be empty";
                            } else if (!emailReg.hasMatch(val)) {
                              return "Please Enter valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ScreenHeight(context) / 25),
                        DefaultFormField(
                          inputType: TextInputType.none,
                          showCursor: false,
                          OnTap: () {
                            passController.text = generatePass();
                          },
                          hintText: "Generate Password",
                          maxLines: 1,
                          isObscureText: true,
                          controller: passController,
                          validate: (val) {
                            if (val == "") {
                              return "You should generate password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ScreenHeight(context) / 25),
                        DefaultFormField(
                          inputType: TextInputType.phone,
                          hintText: "Phone #",
                          controller: phoneController,
                          validate: (val) {
                            return null;
                          },
                        ),
                      ],
                    ),
                    ConditionalBuilder(
                      condition: state is! CreateCoordinatorLoadingState,
                      builder: (context) {
                        return DefaultButton(
                          text: "Add Coordinator",
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.getInstans().createCoor(
                                email: emailController.text,
                                pass: passController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                        );
                      },
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String generatePass() {
    const String charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_#\$@!';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        10,
        (_) => charset.codeUnitAt(random.nextInt(charset.length)),
      ),
    );
  }
}
