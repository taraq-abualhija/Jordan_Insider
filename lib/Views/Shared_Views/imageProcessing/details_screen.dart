import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_cubit.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_state.dart';
import 'package:jordan_insider/Shared/Constants.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});
  static String route = "DetailsScreen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ImageProccessingCubit.getInstans(),
      child: BlocConsumer<ImageProccessingCubit, ImageProccessingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: myAppBar(),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 2),
                    ),
                    margin: EdgeInsets.all(15.dg),
                    width: double.infinity,
                    height: ScreenHeight(context) / 2.3,
                    child: Column(
                      children: [
                        Row(),
                        Row(),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenHeight(context) / 2.5,
                      right: 15.dg,
                      left: 15.dg,
                      bottom: 15.dg,
                    ),
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 2),
                    ),
                    // margin: EdgeInsets.all(15.dg),
                    width: double.infinity,
                    height: ScreenHeight(context) / 2.3,
                    child: Container(
                      padding: EdgeInsets.all(5.dg),
                      child: Column(
                        children: [
                          Text(
                            "More Information",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          ),
                          SizedBox(height: ScreenHeight(context) / 40),
                          Text(
                              "asdasdsadasdasdsadasdasdsadasdasdsadasdasdsadasdasdsadasdasdsadasdasdsadasdasdsadasdasdsad"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget c() {
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Text("data"),
        ],
      ),
    );
  }
}
