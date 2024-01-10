abstract class SearchStates {}

class SearchInitialStates extends SearchStates {}

class SearchLoadingStates extends SearchStates {}

class SearchSuccessStates extends SearchStates {}

class SearchSetAttSuccessStates extends SearchStates {}

class SearchErrorStates extends SearchStates {
  String error;
  SearchErrorStates(this.error);
}
