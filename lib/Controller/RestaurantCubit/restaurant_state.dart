abstract class RestaurantStates {}

class RestaurantInitialState extends RestaurantStates {}

class RestaurantLoadingState extends RestaurantStates {}

class RestaurantSuccessState extends RestaurantStates {}

class RestaurantErrorState extends RestaurantStates {
  String error;
  RestaurantErrorState(this.error);
}
