abstract class ImageProccessingStates {}

class ImageProccessingInitialState extends ImageProccessingStates {}

class ImageProccessingLoadingState extends ImageProccessingStates {}

class ImageProccessingSuccessState extends ImageProccessingStates {}

class ImageProccessingErrorState extends ImageProccessingStates {
  String error;
  ImageProccessingErrorState(this.error);
}
