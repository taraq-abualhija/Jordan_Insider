abstract class ReviewStates {}

class ReviewInitialState extends ReviewStates {}

class ReviewLoadingState extends ReviewStates {}

class ReviewSuccessState extends ReviewStates {}

class ReviewErrorState extends ReviewStates {
  String error;
  ReviewErrorState(this.error);
}
