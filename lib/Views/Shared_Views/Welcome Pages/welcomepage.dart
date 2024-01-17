import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/tourist_user.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/loginpage.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/signuppage.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Tourist_Views/Home%20Page/homepage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static String route = "WelcomePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.dg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DefaultButton(
                text: "Sign up",
                onPressed: () {
                  Navigator.pushNamed(context, SignUp.route);
                },
              ),
              SizedBox(height: ScreenHeight(context) / 50),
              DefaultButton(
                text: "Login",
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.route);
                },
              ),
              SizedBox(height: ScreenHeight(context) / 50),
              DefaultButton(
                text: "continue as guest  ➔",
                onPressed: () {
                  Tourist t = Tourist();
                  t.setFullName("Guest");
                  t.setRoll(3);
                  UserDataCubit.getInstans().userData = t;
                  Navigator.pushNamed(context, TouristHomePage.route);
                },
              ),
              SizedBox(height: ScreenHeight(context) / 10),
            ],
          ),
        ),
      ),
    );
  }
}
