import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/SignupCubit/signup_cubit.dart';
import 'package:jordan_insider/Controller/SignupCubit/signup_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/loginpage.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:motion_toast/motion_toast.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
var confirmPassController = TextEditingController();
var formKey = GlobalKey<FormState>();

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  static String route = "SignUp";
  @override
  Widget build(BuildContext context) {
    RegExp emailReg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExp passReg = RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$");

    return BlocProvider.value(
      value: SignUpCubit.getInstans(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            MotionToast.success(
                    toastDuration: Duration(seconds: 3),
                    position: MotionToastPosition.top,
                    animationCurve: Curves.fastLinearToSlowEaseIn,
                    description: Text("SignUp Success"))
                .show(context);
            Navigator.pushReplacementNamed(context, LoginPage.route);
          } else if (state is SignUpErrorState) {
            MotionToast.error(
                    toastDuration: Duration(seconds: 3),
                    position: MotionToastPosition.top,
                    animationCurve: Curves.fastLinearToSlowEaseIn,
                    description: Text("Something wrong please try again later"))
                .show(context);
          }
        },
        builder: (context, state) {
          SignUpCubit cubit = SignUpCubit.getInstans();
          return Scaffold(
            appBar: myAppBar(),
            body: Container(
              color: Colors.blue[200],
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*Image*/ Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        const Image(
                          image: AssetImage("assets/images/sky.png"),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image(
                              image: AssetImage("assets/images/person.png"),
                              width: 90.h,
                            ),
                            Image(
                              image: AssetImage("assets/images/jarash.png"),
                              width: 150.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.dg),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: UserDataCubit.getInstans().isDark
                              ? Colors.black
                              : Colors.white,
                        ),
                        width: double.infinity,
                        height: ScreenHeight(context) * 2 / 3,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: ScreenHeight(context) / 60),
                              DefaultFormField(
                                inputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                hintText: "Email",
                                controller: emailController,
                                validate: (val) {
                                  if (val == null) {
                                    return "Email can't be empty";
                                  } else if (!emailReg.hasMatch(val)) {
                                    return "Please insert valid email";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: ScreenHeight(context) / 40),
                              DefaultFormField(
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    cubit.eye,
                                    color: UserDataCubit.getInstans().isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    cubit.changePasswordVisibility();
                                  },
                                ),
                                isObscureText: !cubit.isPassShown,
                                hintText: "Password",
                                controller: passwordController,
                                validate: (val) {
                                  if (val == null) {
                                    return "Password can't be empty";
                                  } else if (!passReg.hasMatch(val)) {
                                    return "Password must be contant Minimum eight characters\nat least one uppercase letter, one lowercase letter\nand one number:";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: ScreenHeight(context) / 40),
                              DefaultFormField(
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                isObscureText: !cubit.isPassShown,
                                hintText: "Confirm Password",
                                controller: confirmPassController,
                                validate: (val) {
                                  if (val!.isEmpty) {
                                    return "password does not match";
                                  } else {
                                    if (confirmPassController.text.trim() !=
                                        passwordController.text.trim()) {
                                      return "password does not match";
                                    }
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: ScreenHeight(context) / 40),
                              ConditionalBuilder(
                                condition: state is! SignUpLoadingState,
                                builder: (context) => DefaultButton(
                                  text: "SignUp",
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.signUpUser(
                                          email: emailController.text,
                                          pass: passwordController.text);
                                    }
                                  },
                                ),
                                fallback: (context) =>
                                    CircularProgressIndicator(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account ?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, LoginPage.route);
                                    },
                                    child: Text("Login"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
