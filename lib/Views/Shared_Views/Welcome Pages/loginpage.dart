import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/LoginCubit/login_cubit.dart';
import 'package:jordan_insider/Controller/LoginCubit/login_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Views/Admin/Home/home_page.dart';
import 'package:jordan_insider/Views/Coordinator_Views/HomePage/coorhomepage.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/signuppage.dart';
import 'package:jordan_insider/Views/Tourist_Views/Home%20Page/homepage.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../Shared/Constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static String route = "LoginPage";
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    RegExp emailReg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    var formKey = GlobalKey<FormState>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: LoginCubit.getInstans()),
        BlocProvider.value(value: UserDataCubit.getInstans()),
      ],
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.thisUser != null) {
              UserDataCubit.getInstans().userData = state.thisUser;
              switch (state.thisUser?.getRoll()) {
                case 1:
                  Navigator.pushNamedAndRemoveUntil(
                      context, AdminHomePage.route, (route) => false);
                  break;
                case 2:
                  Navigator.pushNamedAndRemoveUntil(
                      context, CoorHomePage.route, (route) => false);
                  break;
                default:
                  {
                    Navigator.pushNamedAndRemoveUntil(
                        context, TouristHomePage.route, (route) => false);
                  }
              }
            } else {
              MotionToast.warning(
                      toastDuration: Duration(seconds: 3),
                      position: MotionToastPosition.top,
                      animationCurve: Curves.fastLinearToSlowEaseIn,
                      title: Text("Sorry"),
                      description: Text("Email or password are incorrect!"))
                  .show(context);
            }
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.getInstans();
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
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      height: ScreenHeight(context) * 2 / 3,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultFormField(
                              inputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              labelColor: Colors.grey,
                              label: "Email",
                              controller: emailController,
                              validate: (val) {
                                if (val == null) {
                                  return "Email can't be empty";
                                } else if (!emailReg.hasMatch(val)) {
                                  return "Please Enter valid email";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: ScreenHeight(context) / 40),
                            DefaultFormField(
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                icon: Icon(cubit.eye),
                                onPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                              ),
                              isObscureText: !cubit.isPassShown,
                              label: "Password",
                              labelColor: Colors.grey,
                              controller: passwordController,
                              validate: (val) {
                                if (val == null) {
                                  return "Password can't be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: ScreenHeight(context) / 40),
                            /*Login*/ ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) => DefaultButton(
                                text: "Login",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                        email: emailController.text,
                                        pass: passwordController.text);
                                  }
                                },
                              ),
                              fallback: (context) =>
                                  CircularProgressIndicator(),
                            ),
                            SizedBox(height: ScreenHeight(context) / 40),
                            Text("Forgot password?"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account ?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, SignUp.route);
                                  },
                                  child: Text("Sign Up"),
                                ),
                              ],
                            ),
                          ],
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
