// ignore_for_file: avoid_print, file_names

import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jordan_insider/Controller/EventManagementCubit/event_manag_cubit.dart';
import 'package:jordan_insider/Controller/EventManagementCubit/event_manag_states.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Controller/showEventCubit/show_event_cubit.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:logger/logger.dart';
import 'package:motion_toast/motion_toast.dart';

// ignore: must_be_immutable
class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});
  static String route = "AddTicketScreen";

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

List<String> list = <String>['Site', 'Event', 'Restaurant'];

class _AddEventScreenState extends State<AddEventScreen> {
  var eventNameController = TextEditingController();
  var eventDetailsController = TextEditingController();
  var eventDateController = TextEditingController();
  var eventLocController = TextEditingController();
  var eventPriceController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  List<Uint8List?> imagesList = [];
  String noImageadded = "";
  String title = "Add New Event";
  bool isEdit = false;
  SiteEvent? editEvent;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: EventManagementCubit.getInstans()),
        BlocProvider.value(value: UserDataCubit.getInstans()),
      ],
      child: BlocConsumer<EventManagementCubit, EventManagementStates>(
        listener: (context, state) {
          if (state is EventManagementErrorStates) {
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
          } else if (state is EventManagementSuccessStates) {
            eventNameController.clear();
            eventDetailsController.clear();
            eventDateController.clear();
            eventLocController.clear();
            eventPriceController.clear();
            imagesList = [];
            noImageadded = "";
            title = "Add New Event";
            isEdit = false;
            editEvent = null;
          }
        },
        builder: (context, state) {
          var cubit = EventManagementCubit.getInstans();

          if (ShowEventCubit.getInstans().editEventIndex != -1) {
            isEdit = true;
            title = "Edit Event";

            editEvent = EventManagementCubit.getInstans().getIndexedEvent();
            setEventToEdit(editEvent!);
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
                                    controller: eventNameController,
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
                                "Details : ",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            DefaultFormField(
                              textInputAction: TextInputAction.newline,
                              inputType: TextInputType.multiline,
                              controller: eventDetailsController,
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
                                    controller: eventLocController,
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
                            /*Date*/ Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Date : ",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: DefaultFormField(
                                    OnTap: () async {
                                      var date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(
                                              DateTime.now().year + 2));

                                      if (date != null) {
                                        eventDateController.text =
                                            "${date.day}-${date.month}-${date.year}";
                                      }
                                    },
                                    height: 35.h,
                                    controller: eventDateController,
                                    inputType: TextInputType.none,
                                    validate: (val) {
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: ScreenHeight(context) / 50),
                            /*Price*/ Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Price : ",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: DefaultFormField(
                                    height: 35.h,
                                    controller: eventPriceController,
                                    inputType: TextInputType.number,
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
                  condition: state is! EventManagementLoadingStates,
                  builder: (context) => ConditionalBuilder(
                    condition: state is EventManagementSuccessStates,
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
                                        ? updateEvent(cubit)
                                        : saveEvent(cubit);
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
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        crossAxisCount: 2, //العدد بالعرض
        children: <Widget>[
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
            condition: imagesList.length == 2,
            builder: (context) => Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5),
                child: showImage(1),
              ),
            ),
            fallback: (context) =>
                imagesList.isNotEmpty ? addImageButton() : Container(),
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

  void saveEvent(EventManagementCubit cubit) {
    Logger().t("save New Event");
    SiteEvent event = SiteEvent();
    event.setName(eventNameController.text);
    event.setDescription(eventDetailsController.text);
    event.setLocation(eventLocController.text);
    event.setStartDate(eventDateController.text);

    try {
      event.setPrice(double.parse(eventPriceController.text));
    } catch (e) {
      e;
    }

    event.setCoordinatorid(UserDataCubit.getInstans().userData!.getId());
    print(event);
    for (var element in imagesList) {
      if (element != null) {
        event.addImage(element);
      }
    }

    cubit.saveNewEvent(
      event,
    );
  }

  void setEventToEdit(SiteEvent event) {
    eventNameController.text = event.getName();
    eventDetailsController.text = event.getDescription();
    imagesList.addAll(event.getImages());
    eventLocController.text = event.getLocation();
    eventDateController.text = event.getStartDate();
    eventPriceController.text = event.getPrice().toString();
  }

  void updateEvent(EventManagementCubit cubit) {
    // //todo Update Site
    editEvent!.setName(eventNameController.text);
    editEvent!.setDescription(eventDetailsController.text);
    editEvent!.setLocation(eventLocController.text);
    editEvent!.setLocation(eventLocController.text);
    editEvent!.setStartDate(eventDateController.text);
    editEvent!.setCoordinatorid(UserDataCubit.getInstans().userData!.getId());
    try {
      editEvent!.setPrice(double.parse(eventPriceController.text));
    } catch (e) {
      e;
    }

    cubit.updateSite(editEvent!, images: imagesList);
  }
}
