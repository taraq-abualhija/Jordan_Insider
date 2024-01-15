import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_cubit.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_state.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Views/Shared_Views/imageProcessing/details_screen.dart';
import 'package:jordan_insider/utils/ChatGPT/chat_gpt.dart';

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
    ChatGPT.init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    ImageProccessingCubit.getInstans().setImageToProccess(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ImageProccessingCubit.getInstans(),
      child: BlocConsumer<ImageProccessingCubit, ImageProccessingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = ImageProccessingCubit.getInstans();
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
                          condition: cubit.getImage() == null,
                          builder: (context) => CameraPreview(_controller),
                          fallback: (context) => Image.file(
                              File(cubit.getImage()!.path),
                              fit: BoxFit.cover),
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
                          margin: EdgeInsets.only(
                              bottom: 15.dg, right: 10.dg, left: 10.dg),
                          child: Center(
                              child: InkWell(
                            onTap: () async {
                              try {
                                if (cubit.getImage() == null) {
                                  takePicture();
                                } else {
                                  cubit.setImageToProccess(null);
                                  setState(() {});
                                }
                              } catch (e) {
                                logger.e(e);
                              }
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: ConditionalBuilder(
                                condition: cubit.getImage() == null,
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
          }),
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
      XFile image = await _controller.takePicture();

      ImageProccessingCubit.getInstans().setImageToProccess(image);

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, DetailsScreen.route);
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }
}
