// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/NotiCubit/noti_cubit.dart';
import 'package:jordan_insider/Controller/NotiCubit/noti_state.dart';
import 'package:jordan_insider/Models/notification.dart';
import 'package:jordan_insider/Shared/Constants.dart';

bool getNotiFirstTime = true;

class AppNotification extends StatelessWidget {
  const AppNotification({super.key});
  static String route = "AppNotification";
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
                ));
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
