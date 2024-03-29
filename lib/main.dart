import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_state.dart';
import 'package:jordan_insider/Shared/bloc_observer.dart';
import 'package:jordan_insider/Shared/network/local/cache_helper.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Admin/Home/home_page.dart';
import 'package:jordan_insider/Views/Coordinator_Views/HomePage/coorhomepage.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/welcomepage.dart';
import 'package:jordan_insider/Views/Tourist_Views/Home%20Page/homepage.dart';
import 'package:jordan_insider/route.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //*WidgetsFlutterBinding.ensureInitialized();
  //*this line importent because it make sure that
  //*Flutter binding has been initialized before attempting to access services like SharedPreferences
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  String? token = CacheHelper.getData(key: "token");
  bool isDark = CacheHelper.getData(key: "theme") ?? false;
  await dotenv.load();
  Logger().t("Start Run the App");

  runApp(MyApp(token, isDark));
}

bool firstJoin = true;

class MyApp extends StatelessWidget {
  const MyApp(this.token, this.isDark, {super.key});
  final String? token;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: UserDataCubit.getInstans(),
      child: BlocConsumer<UserDataCubit, UserDataStates>(
        listener: (context, state) {},
        builder: (context, state) {
          firstJoin ? UserDataCubit.getInstans().isDark = isDark : null;
          firstJoin = false;
          String goTo = WelcomePage.route;
          if (token != null) {
            UserDataCubit.getInstans().getUserData(token: token!);
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
            switch (decodedToken["RoleId"]) {
              case "1":
                goTo = AdminHomePage.route;
                break;
              case "2":
                goTo = CoorHomePage.route;
                break;
              default:
                goTo = TouristHomePage.route;
            }
          }

          return ScreenUtilInit(
            designSize: Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              darkTheme: ThemeData(
                colorScheme: ColorScheme.dark(),
                // scaffoldBackgroundColor: HexColor('333739'),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.white,
                  selectionColor: Colors.blue,
                  selectionHandleColor: Colors.blue,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                cardTheme: CardTheme(color: Color.fromARGB(255, 40, 40, 40)),
                appBarTheme: AppBarTheme(
                  color: mainColor,
                  centerTitle: true,
                  actionsIconTheme: IconThemeData(color: Colors.white),
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                      color: Colors.white, fontSize: ScreenWidth(context) / 15),
                ),
              ),
              theme: ThemeData(
                colorScheme: ColorScheme.light(),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.black,
                  selectionColor: Colors.blue,
                  selectionHandleColor: Colors.blue,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                cardTheme: CardTheme(color: Color.fromARGB(255, 200, 200, 200)),
                appBarTheme: AppBarTheme(
                  color: mainColor,
                  centerTitle: true,
                  actionsIconTheme: IconThemeData(color: Colors.white),
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                      color: Colors.white, fontSize: ScreenWidth(context) / 15),
                ),
              ),
              themeMode: UserDataCubit.getInstans().isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              initialRoute: goTo,
              routes: getRouts(),
            ),
          );
        },
      ),
    );
  }
}
