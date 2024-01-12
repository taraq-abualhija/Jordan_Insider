import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_state.dart';
import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';
import 'package:jordan_insider/utils/intent_utils/intent_utils.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialStates());
  static SearchCubit? _cubit;

  static SearchCubit getInstans() {
    _cubit ??= SearchCubit();
    return _cubit!;
  }

  final List<Attraction> _attractions = [];
  final List<Restaurant> restaurant = [];

  void setAttraction(List<Attraction> a) {
    _attractions.clear();
    restaurant.clear();
    _attractions.addAll(a);
    emit(SearchSuccessStates());
  }

  List<Attraction> getAttractions() => _attractions;

  void getRestaurants() {
    emit(SearchLoadingStates());
    IntentUtils.getNearbyPlaces(radius: 3000).then((value) {
      _attractions.clear();
      restaurant.clear();
      restaurant.addAll(value);
      emit(SearchSuccessStates());
    }).catchError((error) {
      emit(SearchErrorStates(error.toString()));
    });
  }

  void justEmit() {
    emit(SearchInitialStates());
  }

  void searchSites(String name) {
    _attractions.clear();
    restaurant.clear();
    emit(SearchLoadingStates());
    DioHelper.updateData(url: SearchTouristSiteByName + name, data: {})
        .then((value) async {
      for (var element in value.data) {
        _attractions.add(Site.fromJSON(element));
        await Future.delayed(Duration(milliseconds: 500));
      }
      emit(SearchSuccessStates());
    }).catchError((error) {
      emit(SearchErrorStates(error.toString()));
    });
  }
}
