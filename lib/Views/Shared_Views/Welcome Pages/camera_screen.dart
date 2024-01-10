import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Shared/Constants.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  static String route = "CameraScreen";

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    _controller = CameraController(
      CameraDescription(
          sensorOrientation: 1,
          name: '0',
          lensDirection: CameraLensDirection.back),
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConditionalBuilder(
                  condition: image == null,
                  builder: (context) => CameraPreview(_controller),
                  fallback: (context) =>
                      Image.file(File(image!.path), fit: BoxFit.cover),
                ),
                /*Cam Button*/ Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: const [
                        Color.fromARGB(255, 21, 122, 204),
                        Color.fromARGB(255, 41, 54, 133),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: const [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(bottom: 15.dg, right: 10.dg, left: 10.dg),
                  child: Center(
                      child: InkWell(
                    onTap: () async {
                      try {
                        if (image == null) {
                          takePicture();
                        } else {
                          image = null;
                          setState(() {});
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: ConditionalBuilder(
                        condition: image == null,
                        builder: (context) {
                          return CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 23,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 21.5,
                            ),
                          );
                        },
                        fallback: (context) {
                          return Icon(
                            Icons.close_rounded,
                            color: Colors.red,
                            size: 30.sp,
                          );
                        },
                      ),
                    ),
                  )),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }

  Future takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      await _controller.setFlashMode(FlashMode.off);
      image = await _controller.takePicture();
      setState(() {});
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }
}
