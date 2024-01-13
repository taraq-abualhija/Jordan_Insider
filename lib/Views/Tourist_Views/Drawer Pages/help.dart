// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({super.key});
  static String route = "Help";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: Text("Help")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Call us on : ",
                style: TextStyle(fontSize: 20.sp),
              ),
              TextButton(
                child: Text(
                  "Email",
                  style: TextStyle(fontSize: 20.sp),
                ),
                onPressed: () {
                  _launchEmail(context);
                },
              ),
            ],
          ),
          Text(
            "-------------OR-------------",
            style: TextStyle(fontSize: 20.sp),
          ),
          DefaultButton(
            text: "Download App manual",
            onPressed: () {},
          )
        ],
      ),
    );
  }

  void _launchEmail(context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'justjordaninsider@gmail.com',
    );

    await launchUrl(emailLaunchUri);
  }
}
