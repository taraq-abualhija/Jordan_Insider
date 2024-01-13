import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_state.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:http/http.dart' as http;

import '../../utils/intent_utils/intent_utils.dart';

class ImageProccessingCubit extends Cubit<ImageProccessingStates> {
  ImageProccessingCubit() : super(ImageProccessingInitialState());
  static ImageProccessingCubit? _cubit;

  static ImageProccessingCubit getInstans() {
    _cubit ??= ImageProccessingCubit();
    return _cubit!;
  }

  XFile? _image;

  XFile? getImage() => _image;
  void setImageToProccess(XFile? image) {
    _image = image;
    emit(ImageProccessingSuccessState());
  }

  void findImage() {}

  Future<void> askGPT(String msg) async {
    await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['token']}'
      },
      body: jsonEncode(
        {
          "model": "davinci-002",
          "prompt": msg,
          "max_tokens": 250,
          "temperature": 0,
          "top_p": 1,
        },
      ),
    );
  }

  Set<Restaurant> nearbyRest = {};

  void searcForRest() {
    emit(SearchForRestLoadingState());
    IntentUtils.getNearbyPlaces().then((value) {
      nearbyRest.clear();
      nearbyRest.addAll(value);
      emit(ImageProccessingSuccessState());
    }).catchError((error) {
      emit(SearchForRestErrorState());
    });
  }
}
