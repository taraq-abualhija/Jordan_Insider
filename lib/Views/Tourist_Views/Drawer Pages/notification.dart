// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/NotiCubit/noti_cubit.dart';
import 'package:jordan_insider/Controller/NotiCubit/noti_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/notification.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/welcomepage.dart';

// ignore: must_be_immutable
class AppNotification extends StatelessWidget {
  AppNotification({super.key});
  static String route = "AppNotification";
  bool getNotiFirstTime = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: NotificationCubit.getInstans(),
      child: BlocConsumer<NotificationCubit, NotificationStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = NotificationCubit.getInstans();
            if (getNotiFirstTime) {
              cubit.getAllNotification();
              getNotiFirstTime = false;
            }
            return Scaffold(
              appBar: myAppBar(title: Text("Notification")),
              body: ConditionalBuilder(
                condition:
                    UserDataCubit.getInstans().userData!.getEmail().isNotEmpty,
                builder: (context) {
                  return ConditionalBuilder(
                    condition: state is! GetNotificationLoadingState,
                    builder: (context) {
                      return ListView.builder(
                        itemCount: cubit.userNoti.length,
                        itemBuilder: (context, index) =>
                            notiCard(cubit.userNoti[index]),
                      );
                    },
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  );
                },
                fallback: (context) => Center(
                    child: Container(
                  margin: EdgeInsets.all(20.dg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login to see your Notification",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      DefaultButton(
                        text: "Go to Login ->",
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, WelcomePage.route, (route) => false);
                        },
                      )
                    ],
                  ),
                )),
              ),
            );
          }),
    );
  }

  Widget notiCard(NotificationModel noti) {
    return Dismissible(
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.dg),
        margin: EdgeInsets.only(top: 10.dg),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 25.sp,
            ),
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 25.sp,
            ),
          ],
        ),
      ),
      key: Key(noti.getNotificationMsg()),
      onDismissed: (e) {
        NotificationCubit.getInstans()
            .deleteNotification(noti.getNotificationId());
      },
      child: Card(
        borderOnForeground: true,
        elevation: 5,
        margin: EdgeInsets.only(top: 10.dg, right: 10.dg, left: 10.dg),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 7.5.dg),
          alignment: Alignment.centerLeft,
          height: 75.h,
          child: Text(noti.getNotificationMsg(),
              style: TextStyle(fontSize: 20.sp)),
        ),
      ),
    );
  }
}
