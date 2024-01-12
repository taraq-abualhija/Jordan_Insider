import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_state.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/utils/intent_utils/intent_utils.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialStates());
  static SearchCubit? _cubit;

  static SearchCubit getInstans() {
    _cubit ??= SearchCubit();
    return _cubit!;
  }

  final List<Attraction> _attractions = [];
  final List<Restaurant> _restaurant = [];

  void setAttraction(List<Attraction> a) {
    _attractions.clear();
    _restaurant.clear();
    _attractions.addAll(a);
    emit(SearchSetAttSuccessStates());
  }

  List<Attraction> getAttractions() => _attractions;

  void getRestaurants() {
    emit(SearchLoadingStates());
    IntentUtils.getNearbyPlaces(radius: 5000).then((value) {
      _attractions.clear();
      _restaurant.clear();
      _restaurant.addAll(value);
      emit(SearchSuccessStates());
    }).catchError((error) {
      emit(SearchErrorStates(error.toString()));
    });
  }

  void justEmit() {
    emit(SearchInitialStates());
  }
}
