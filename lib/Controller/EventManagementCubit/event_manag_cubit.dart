import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/EventManagementCubit/event_manag_states.dart';
import 'package:jordan_insider/Controller/showEventCubit/show_event_cubit.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class EventManagementCubit extends Cubit<EventManagementStates> {
  EventManagementCubit() : super(EventManagementInitialStates());

  static EventManagementCubit? _cubit;

  static EventManagementCubit getInstans() {
    _cubit ??= EventManagementCubit();

    return _cubit!;
  }

  SiteEvent getIndexedEvent() {
    int editSiteIndex = ShowEventCubit.getInstans().getEditEventIndex();
    SiteEvent event = ShowEventCubit.getInstans().events[editSiteIndex];
    return event;
  }

  saveNewEvent(SiteEvent event) {
    emit(EventManagementLoadingStates());

    String? image1;
    String? image2;

    DioHelper.uploadImageToServer(event.getImages()).then((value) {
      image1 = value.data["image1"]?.toString();
      image2 = value.data["image2"]?.toString();

      logger.t("Upload Image To Server Successfully");

      //$Save the Event
      DioHelper.postData(
        url: CreateEvent,
        data: {
          'name': event.getName(),
          "coordinatorid": event.getCoordinatorid(),
          "eventid": 0,
          'datestart': event.getStartDate(),
          'details': event.getDescription(),
          'location': event.getLocation(),
          'image1': image1,
          'image2': image2
        },
      ).then((value) async {
        logger.t("Create New Events Successfully");
        emit(EventManagementSuccessStates());
        await Future.delayed(Duration(seconds: 3));
        emit(EventManagementInitialStates());
      }).catchError((error) async {
        emit(EventManagementErrorStates(error.toString()));
        logger.e(error);
      });
      //$End Save the Event
    });
  }

  updateSite(SiteEvent event, {List<Uint8List?>? images}) {
    List<String?> newImagesName = [];
    if (images != null) {
      for (var element in event.getImages()) {
        if (images.contains(element)) {
          images.remove(element);
          newImagesName
              .add(event.getImagesNames()[event.getImages().indexOf(element)]!);
        }
      }
      //$Upload New Image To Server
      DioHelper.uploadImageToServer(images).then((value) {
        newImagesName.add(value.data["image1"]?.toString());
        newImagesName.add(value.data["image2"]?.toString());

        DioHelper.updateData(
          url: UpdateEvent,
          data: {
            "name": event.getName(),
            "eventid": event.getID(),
            "coordinatorid": event.getCoordinatorid(),
            "datestart": event.getStartDate(),
            "details": event.getDescription(),
            "image1": newImagesName.isNotEmpty ? newImagesName[0] : null,
            "image2": newImagesName.length >= 2 ? newImagesName[1] : null,
            "location": event.getLocation()
          },
        ).then((value) async {
          emit(EventManagementSuccessStates());
          await Future.delayed(Duration(seconds: 3));
          emit(EventManagementInitialStates());
        }).catchError((error) {
          emit(EventManagementErrorStates(error));
        });
      }).catchError((error) {
        emit(EventManagementErrorStates(error));
      });
    } else {
      newImagesName.addAll(event.getImagesNames());

      DioHelper.updateData(
        url: UpdateEvent,
        data: {
          "name": event.getName(),
          "eventid": event.getID(),
          "datestart": event.getStartDate(),
          "details": event.getDescription(),
          "image1": newImagesName.isNotEmpty ? newImagesName[0] : null,
          "image2": newImagesName.length >= 2 ? newImagesName[1] : null,
          "location": event.getLocation()
        },
      ).then((value) async {
        emit(EventManagementSuccessStates());
        await Future.delayed(Duration(seconds: 3));
        emit(EventManagementInitialStates());
      }).catchError((error) {
        emit(EventManagementErrorStates(error));
      });
    }
  }
}
