import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_state.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

import '../../utils/intent_utils/intent_utils.dart';

class ImageProccessingCubit extends Cubit<ImageProcessingStates> {
  ImageProccessingCubit() : super(ImageProcessingInitialState());
  static ImageProccessingCubit? _cubit;

  static ImageProccessingCubit getInstans() {
    _cubit ??= ImageProccessingCubit();
    return _cubit!;
  }

  XFile? _image;

  XFile? getImage() => _image;
  void setImageToProccess(XFile? image) {
    _image = image;
    emit(ImageProcessingSuccessState());
  }

  Site? site;
  Future<void> searchForImage() async {
    emit(ImageProcessingLoadingState());
    DioHelper.postData(
        url: "http://20.203.96.69:81/detect",
        data: {"image_data": await _image!.readAsBytes()}).then((value) {
      print("================================");
      print(value.data);
      print("================================");

      searchSiteInDB(value.data['object']); //Todo value.data['object']
    }).catchError((error) {
      emit(ImageProcessingErrorState());
      logger.e(error);
    });
  }

  void searchSiteInDB(String imageTitle) {
    if (imageTitle == "JUST Gate") {
      imageTitle = "Jordan University of Science and Technology";
    }
    if (imageTitle == "Roman amphitheater") {
      imageTitle = "Roman";
    }
    emit(SearchSiteInDBLoadingState());
    DioHelper.updateData(url: SearchTouristSiteByName + imageTitle, data: {})
        .then((value) async {
      site = Site.fromJSON(value.data[0]);
      await Future.delayed(Duration(seconds: 3));
      print("*****************************");
      print("Site Id : ${site!.getID()}");
      print("*****************************");
      emit(SearchSiteInDBSuccessState());
    }).catchError((error) {
      emit(SearchSiteInDBErrorState());
      print(error);
    });
  }

  Set<Restaurant> nearbyRest = {};

  void searcForRest() {
    emit(SearchForRestLoadingState());
    IntentUtils.getNearbyPlaces().then((value) {
      nearbyRest.clear();
      nearbyRest.addAll(value);
      emit(SearchForRestsuccessState());
    }).catchError((error) {
      emit(SearchForRestErrorState());
    });
  }
}
