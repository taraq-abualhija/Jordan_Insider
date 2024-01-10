import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jordan_insider/Controller/SignupCubit/signup_cubit.dart';
import 'package:jordan_insider/Controller/SignupCubit/signup_state.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/loginpage.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:motion_toast/motion_toast.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  static String route = "SignUp";
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPassController = TextEditingController();
    RegExp emailReg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExp passReg = RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$");
    var formKey = GlobalKey<FormState>();

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
            resizeToAvoidBottomInset: false,
            appBar: myAppBar(),
            body: Container(
              color: Colors.blue[200],
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        const Image(
                          image: AssetImage("assets/images/sky.png"),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: ScreenWidth(context) / 3,
                          alignment: Alignment.bottomLeft,
                          child: Image(
                            image: AssetImage("assets/images/person.png"),
                            width: 90.h,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.bottomRight,
                          // color: Colors.amber,
                          child: Image(
                            image: AssetImage("assets/images/jarash.png"),
                            width: 210.w,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.dg),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      height: ScreenHeight(context) * 2 / 3,
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
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
                                  icon: Icon(cubit.eye),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 120,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                              thickness: .8,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "OR",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            thickness: .8,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign up with",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenHeight(context) / 60),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80),
                                child: Container(
                                  height: 55,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: SvgPicture.asset(
                                      "assets/images/icons8-google.svg"),
                                ),
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