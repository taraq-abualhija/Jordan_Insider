abstract class ImageProccessingStates {}

class ImageProccessingInitialState extends ImageProccessingStates {}

class ImageProccessingLoadingState extends ImageProccessingStates {}

class ImageProccessingSuccessState extends ImageProccessingStates {}

class SearchForRestLoadingState extends ImageProccessingStates {}

class SearchForRestsuccessState extends ImageProccessingStates {}

class SearchForRestErrorState extends ImageProccessingStates {}

class ImageProccessingErrorState extends ImageProccessingStates {
  String error;
  ImageProccessingErrorState(this.error);
}
