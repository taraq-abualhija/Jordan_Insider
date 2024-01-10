// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Controller/SiteManagementCubit/site_states.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';
import 'package:logger/logger.dart';
import '../../Shared/network/end_points.dart';

class SiteManagementCubit extends Cubit<SiteManagementStates> {
  SiteManagementCubit() : super(SiteManagementInitialStates());

  static SiteManagementCubit? _cubit;

  static SiteManagementCubit getInstans() {
    _cubit ??= SiteManagementCubit();
    return _cubit!;
  }

  Site getIndexedSite() {
    int editSiteIndex = ShowSiteCubit.getInstans().getEditSiteIndex();
    Site site = ShowSiteCubit.getInstans().coorSite[editSiteIndex];
    return site;
  }

  saveNewSite(Site site) {
    emit(SiteManagementLoadingStates());

    String? image1;
    String? image2;
    String? image3;
    String? image4;

    DioHelper.uploadImageToServer(site.getImages()).then((value) {
      image1 = value.data["image1"]?.toString();
      image2 = value.data["image2"]?.toString();
      image3 = value.data["image3"]?.toString();
      image4 = value.data["image4"]?.toString();

      logger.t("Upload Image To Server Successfully");

      //$Save the site :
      DioHelper.postData(
        url: CreateTouristSite,
        data: {
          "touristsiteid": 1,
          "coordinatorid": site.getCoordinatorid(),
          "name": site.getName(),
          "description": site.getDescription(),
          "image1": image1,
          "image2": image2,
          "image3": image3,
          "image4": image4,
          "location": site.getLocation(),
          "tfrom": site.getTimeFrom(),
          "tto": site.getTimeTo()
        },
      ).then((value) async {
        Logger().t("Create Tourist Site Successfully");
        print(value.data);
        emit(SiteManagementSuccessStates());
        await Future.delayed(Duration(seconds: 3));
        emit(SiteManagementInitialStates());
      }).catchError((error) async {
        emit(SiteManagementErrorStates(error.toString()));
        logger.e(error);
      });
      //$ End of Save the site
    }).catchError((error) {
      logger.e(error);
      emit(SiteManagementErrorStates(error.toString()));
    });
  }

  updateSite(Site site, {required List<Uint8List?> images}) async {
    emit(SiteManagementLoadingStates());

    Set<String?> newImagesName = {};
    if (images.isNotEmpty) {
      for (var element in site.getImages()) {
        if (images.contains(element)) {
          images.remove(element);
          newImagesName
              .add(site.getImagesNames()[site.getImages().indexOf(element)]!);
        }
      }
      if (images.isNotEmpty) {
        //$ if Not Empty that mean there is new Image and I want to upload them
        await DioHelper.uploadImageToServer(images).then((value) {
          for (var i = 1; i <= 4; i++) {
            if (value.data["image$i"] != null) {
              newImagesName.add(value.data["image$i"].toString());
            }
          }
        }).catchError((error) {
          emit(SiteManagementErrorStates(error.toString()));
        });
      }
    }
    //$ End of uploadImageToServer
    //$ Start update site
    try {
      DioHelper.updateData(
        url: UpdateTouristSite,
        data: {
          "touristsiteid": site.getID(),
          "coordinatorid": site.getCoordinatorid(),
          "name": site.getName(),
          "description": site.getDescription(),
          "image1":
              newImagesName.isNotEmpty ? newImagesName.elementAt(0) : null,
          "image2":
              newImagesName.length >= 2 ? newImagesName.elementAt(1) : null,
          "image3":
              newImagesName.length >= 3 ? newImagesName.elementAt(2) : null,
          "image4":
              newImagesName.length == 4 ? newImagesName.elementAt(3) : null,
          "location": site.getLocation(),
          "tfrom": site.getTimeFrom(),
          "tto": site.getTimeTo()
        },
      ).then((value) async {
        print(value.data);
        emit(SiteManagementSuccessStates());
        await Future.delayed(Duration(seconds: 3));
        emit(SiteManagementInitialStates());
      }).catchError((error) {
        logger.e(error);
        emit(SiteManagementErrorStates(error.toString()));
      });
    } catch (e) {
      logger.e(e);
    }

    //$ End update site
  }
}
