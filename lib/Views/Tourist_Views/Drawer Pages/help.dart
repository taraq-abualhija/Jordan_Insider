import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';

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
            width: ScreenWidth(context) / 2,
            text: "Download App manual",
            onPressed: () {
              _downloadHelp(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> _downloadHelp(context) async {
    if (!FlutterDownloader.initialized) {
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize(debug: true);
    }

    String? downloadDir = await _chooseSaveLocation();

    if (downloadDir != null) {
      final filePath = join(downloadDir, 'help.docx');

      ByteData data = await rootBundle.load('assets/help.docx');
      List<int> bytes = data.buffer.asUint8List();

      File file = File(filePath);
      await file.writeAsBytes(bytes);

      try {
        await FlutterDownloader.enqueue(
          url: 'file://$filePath',
          savedDir: downloadDir,
          showNotification: true,
          openFileFromNotification: true,
        ).then((value) {
          MotionToast.success(
            description: Text("Seccess Download App Manual."),
            position: MotionToastPosition.center,
          ).show(context);
        }).catchError((error) {
          logger.e(error);
        });
      } catch (e) {
        logger.e("Error : $e");
      }
    }
  }

  Future<String?> _chooseSaveLocation() async {
    try {
      var result = await FilePicker.platform.getDirectoryPath();

      if (result != null) {
        // Return the selected directory
        return result;
      } else {
        // User canceled the directory picking

        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void _launchEmail(context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'justjordaninsider@gmail.com',
    );

    await launchUrl(emailLaunchUri);
  }
}
