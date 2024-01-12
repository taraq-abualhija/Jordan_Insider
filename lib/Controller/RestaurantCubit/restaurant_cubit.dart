import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/RestaurantCubit/restaurant_state.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/utils/intent_utils/intent_utils.dart';

class RestaurantCubit extends Cubit<RestaurantStates> {
  RestaurantCubit() : super(RestaurantInitialState());

  static RestaurantCubit? _cubit;

  static RestaurantCubit getInstans() {
    _cubit ??= RestaurantCubit();
    return _cubit!;
  }

  Set<Restaurant> nearByRestaurants = {};

  Future<void> getNearByRestaurants() async {
    emit(RestaurantLoadingState());
    IntentUtils.getNearbyPlaces().then((value) {
      nearByRestaurants.clear();
      nearByRestaurants.addAll(value);
      emit(RestaurantSuccessState());
    }).catchError((error) {
      emit(RestaurantErrorState(error.toString()));
    });
  }
}
