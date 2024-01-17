// ignore_for_file: avoid_print, file_names
//Todo لما يفوت على الكيوبت اول مره و يطلع بصير في مشكله بال إيمت ستيت
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/SiteManagementCubit/site_cubit.dart';
import 'package:jordan_insider/Controller/SiteManagementCubit/site_states.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:logger/logger.dart';
import 'package:motion_toast/motion_toast.dart';

// ignore: must_be_immutable
class AddSitePage extends StatefulWidget {
  const AddSitePage({super.key});
  static String route = "AddSitePage";

  @override
  State<AddSitePage> createState() => _AddSitePageState();
}

class _AddSitePageState extends State<AddSitePage> {
  var siteNameController = TextEditingController();
  var siteDescController = TextEditingController();
  var siteLocController = TextEditingController();
  var siteTimeFromController = TextEditingController();
  var siteTimeToController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  List<Uint8List?> imagesList = [];
  String title = "Add New Site";
  bool isEdit = false;
  Site? editSite;
  String noImageadded = "";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: SiteManagementCubit.getInstans()),
        BlocProvider.value(value: UserDataCubit.getInstans()),
      ],
      child: BlocConsumer<SiteManagementCubit, SiteManagementStates>(
        listener: (context, state) {
          if (state is SiteManagementErrorStates) {
            try {
              MotionToast.error(
                      toastDuration: Duration(seconds: 3),
                      position: MotionToastPosition.top,
                      animationCurve: Curves.fastLinearToSlowEaseIn,
                      title: Text("Error"),
                      description:
                          Text("Something is wrong!\nPlease try again later."))
                  .show(context);
            } catch (e) {
              logger.e(e);
            }
          } else if (state is SiteManagementSuccessStates) {
            siteNameController.clear();
            siteDescController.clear();
            siteTimeFromController.clear();
            siteTimeToController.clear();
            siteLocController.clear();
            imagesList = [];
            noImageadded = "";
            title = "Add New Site";
            isEdit = false;
            editSite = null;
          }
        },
        builder: (context, state) {
          var cubit = SiteManagementCubit.getInstans();

          if (ShowSiteCubit.getInstans().editSiteIndex != -1) {
            isEdit = true;
            title = "Edit Site";
            editSite = SiteManagementCubit.getInstans().getIndexedSite();
            setSiteToEdit(editSite!);
          }

          return Scaffold(
            appBar: myAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(10.dg),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 15.sp),
                            ),
                            SizedBox(height: ScreenHeight(context) / 75),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Name : ",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: DefaultFormField(
                                    textInputAction: TextInputAction.next,
                                    height: 35.h,
                                    controller: siteNameController,
                                    validate: (val) {
                                      if (val == null) {
                                        return "Name Can't be Null!";
                                      } else if (val.length < 3) {
                                        return "Name is too short!";
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: ScreenHeight(context) / 75),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Description : ",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            DefaultFormField(
                              textInputAction: TextInputAction.newline,
                              inputType: TextInputType.multiline,
                              controller: siteDescController,
                              validate: (val) {
                                return null;
                              },
                            ),
                            SizedBox(height: ScreenHeight(context) / 75),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Images : ",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            Container(
                              height: ScreenHeight(context) / 5,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: setGridView(),
                            ),
                            Text(
                              noImageadded,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: ScreenHeight(context) / 75),
                            /*Location*/ Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Location",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: DefaultFormField(
                                    height: 35.h,
                                    controller: siteLocController,
                                    validate: (val) {
                                      if (val == "") {
                                        return "You should add Location";
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: ScreenHeight(context) / 75),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Available Time : ",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            /*From*/ Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "From : ",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: DefaultFormField(
                                    OnTap: () async {
                                      siteTimeFromController.text =
                                          await showMyTimePicker(context,
                                              siteTimeFromController.text);
                                      // print(time);
                                    },
                                    height: 35.h,
                                    controller: siteTimeFromController,
                                    inputType: TextInputType.none,
                                    validate: (val) {
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: ScreenHeight(context) / 75),
                            /*To*/ Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "To : ",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: DefaultFormField(
                                    OnTap: () async {
                                      siteTimeToController.text =
                                          await showMyTimePicker(context,
                                              siteTimeToController.text);
                                    },
                                    inputType: TextInputType.none,
                                    height: 35.h,
                                    controller: siteTimeToController,
                                    validate: (val) {
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: ScreenHeight(context) / 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: state is! SiteManagementLoadingStates,
                  builder: (context) => ConditionalBuilder(
                    condition: state is SiteManagementSuccessStates,
                    builder: (context) {
                      try {
                        AudioPlayer()
                            .play(AssetSource('sounds/Done add Site.mp3'));
                      } catch (e) {
                        logger.e("ERROR in the sound $e");
                      }
                      return Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 75.sp,
                      );
                    },
                    fallback: (context) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.dg),
                            child: DefaultButton(
                              color: Colors.green,
                              text: isEdit ? "Update" : "Save",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (imagesList.isNotEmpty) {
                                    isEdit
                                        ? updateSite(cubit)
                                        : saveSite(cubit);
                                    noImageadded = "";
                                  } else {
                                    setState(() {
                                      noImageadded =
                                          "Please add one image at least!";
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.dg),
                            child: DefaultButton(
                              color: Colors.red,
                              text: "Cancel",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  fallback: (context) => CircularProgressIndicator(),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> showMyTimePicker(context, String previousTime) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: DateTime.now().hour, minute: DateTime.now().minute));
    if (time != null) {
      return time.format(context);
    }
    return previousTime;
  }

  Widget setGridView() {
    Logger().t("setGridView");
    try {
      return GridView.count(
        primary: false,
        crossAxisCount: 2, //العدد بالعرض
        children: <Widget>[
          Column(
            children: [
              ConditionalBuilder(
                condition: imagesList.isNotEmpty,
                builder: (context) => Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    child: showImage(0),
                  ),
                ),
                fallback: (context) =>
                    imagesList.isEmpty ? addImageButton() : Container(),
              ),
              ConditionalBuilder(
                condition: imagesList.length >= 3,
                builder: (context) => Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    child: showImage(2),
                  ),
                ),
                fallback: (context) => Container(),
              ),
            ],
          ),
          Column(
            children: [
              ConditionalBuilder(
                condition: imagesList.length >= 2,
                builder: (context) => Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    child: showImage(1),
                  ),
                ),
                fallback: (context) =>
                    imagesList.length == 1 ? addImageButton() : Container(),
              ),
              ConditionalBuilder(
                condition: imagesList.length >= 4,
                builder: (context) => Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    child: showImage(3),
                  ),
                ),
                fallback: (context) => // 0 1 // 0 1 2 3
                    imagesList.length >= 2 ? addImageButton() : Container(),
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      Logger().e(e);
      return Container();
    }
  }

  Widget showImage(int index) {
    return InkWell(
      onTap: () {
        popupImage(index);
      },
      onLongPress: () {},
      child: Image.memory(imagesList[index]!, fit: BoxFit.fill),
    );
  }

  void popupImage(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.memory(imagesList[index]!,
                fit: BoxFit.fill, height: ScreenHeight(context) / 3),
            actions: <Widget>[
              Center(
                child: InkWell(
                  onTap: () {
                    imagesList.removeAt(index);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.dg),
                    margin: EdgeInsets.symmetric(horizontal: 10.dg),
                    width: double.infinity,
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget addImageButton() {
    Logger().t("addImageButton");
    return Expanded(
      child: InkWell(
        onTap: () {
          print("One Image added to the List!");
          _pickImageFromGallery();
        },
        child: Image.asset(
          UserDataCubit.getInstans().isDark
              ? "assets/images/addImagewhite.png"
              : "assets/images/addImage.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        imagesList.add(File(image!.path).readAsBytesSync());
      });
    } catch (e) {
      Logger().e("Error in _pickImageFromGallery $e");
    }
  }

  void setSiteToEdit(Site editSite) {
    siteNameController.text = editSite.getName();
    siteDescController.text = editSite.getDescription();
    siteLocController.text = editSite.getLocation();
    siteTimeFromController.text = editSite.getTimeFrom();
    siteTimeToController.text = editSite.getTimeTo();
    imagesList.addAll(editSite.getImages());
  }

  void saveSite(SiteManagementCubit cubit) {
    Site site = Site();
    site.setName(siteNameController.text);
    site.setLocation(siteLocController.text);
    site.setDescription(siteDescController.text);
    site.setLocation(siteLocController.text);
    site.setTimeFrom(siteTimeFromController.text);
    site.setTimeTo(siteTimeToController.text);
    site.setCoordinatorid(UserDataCubit.getInstans().userData!.getId());
    for (var element in imagesList) {
      if (element != null) {
        site.addImage(element);
      }
    }

    cubit.saveNewSite(site);
  }

  void updateSite(SiteManagementCubit cubit) {
    editSite!.setName(siteNameController.text);
    editSite!.setDescription(siteDescController.text);
    editSite!.setLocation(siteLocController.text);
    editSite!.setTimeFrom(siteTimeFromController.text);
    editSite!.setTimeTo(siteTimeToController.text);
    editSite!.setCoordinatorid(UserDataCubit.getInstans().userData!.getId());
    List<Uint8List?> temp = [];
    temp.addAll(imagesList);
    cubit.updateSite(editSite!, images: temp);
  }
}
