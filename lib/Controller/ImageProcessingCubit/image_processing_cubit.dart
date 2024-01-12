import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/ImageProcessingCubit/image_processing_state.dart';

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
}
