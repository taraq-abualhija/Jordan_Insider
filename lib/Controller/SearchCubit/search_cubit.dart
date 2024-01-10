import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/SearchCubit/search_state.dart';
import 'package:jordan_insider/Models/attraction.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialStates());
  static SearchCubit? _cubit;

  static SearchCubit getInstans() {
    _cubit ??= SearchCubit();
    return _cubit!;
  }

  final List<Attraction> _attractions = [];

  void setAttraction(List<Attraction> a) {
    _attractions.clear();
    _attractions.addAll(a);
    emit(SearchSetAttSuccessStates());
  }

  List<Attraction> getAttractions() => _attractions;

  void justEmit() {
    emit(SearchInitialStates());
  }
}
