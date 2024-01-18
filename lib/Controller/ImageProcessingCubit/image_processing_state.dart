abstract class ImageProcessingStates {}

class ImageProcessingInitialState extends ImageProcessingStates {}

class ImageProcessingLoadingState extends ImageProcessingStates {}

class ImageProcessingSuccessState extends ImageProcessingStates {}

class ImageProcessingErrorState extends ImageProcessingStates {}

class SearchForRestLoadingState extends ImageProcessingStates {}

class SearchForRestsuccessState extends ImageProcessingStates {}

class SearchForRestErrorState extends ImageProcessingStates {}

class SearchSiteInDBLoadingState extends ImageProcessingStates {}

class SearchSiteInDBSuccessState extends ImageProcessingStates {}

class SearchSiteInDBErrorState extends ImageProcessingStates {}
