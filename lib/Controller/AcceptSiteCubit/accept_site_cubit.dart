import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/AcceptSiteCubit/accept_site_state.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_cubit.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class AcceptSiteCubit extends Cubit<AcceptSiteStates> {
  AcceptSiteCubit() : super(AcceptSiteInitialStates());
  static AcceptSiteCubit? _cubit;

  static AcceptSiteCubit getInstans() {
    _cubit ??= AcceptSiteCubit();
    return _cubit!;
  }

  Site? _showSite;

  void setSiteToAcceptScreen(Site site) {
    _showSite = site;
  }

  Site? getSiteToAcceptScreen() => _showSite;

  void acceptSite() {
    emit(AcceptSiteLoadingStates());
    if (_showSite != null) {
      DioHelper.updateData(
          url: AcceptTouristSite + _showSite!.getID().toString(),
          data: {}).then((value) {
        _showSite!.setStatus("Accepted");
        try {
          ShowSiteCubit.getInstans().pendingSites.removeWhere((element) {
            return element.getID() == _showSite!.getID();
          });

          ShowSiteCubit.getInstans().acceptedSites.add(_showSite!);
        } catch (e) {
          e;
        }
        _showSite = null;
        emit(AcceptSiteSuccessStates());
      }).catchError((error) {
        emit(AcceptSiteErrorStates(error.toString()));
      });
    }
  }

  void rejectSite() {
    emit(AcceptSiteLoadingStates());
    if (_showSite != null) {
      DioHelper.deleteData(
        url: DeleteTouristSite + _showSite!.getID().toString(),
      ).then((value) {
        try {
          ShowSiteCubit.getInstans().pendingSites.removeWhere((element) {
            return element.getID() == _showSite!.getID();
          });
          ShowSiteCubit.getInstans().allSites.removeWhere((element) {
            return element.getID() == _showSite!.getID();
          });
          _showSite = null;
        } catch (e) {
          e;
        }
        _showSite = null;
        emit(AcceptSiteSuccessStates());
      }).catchError((error) {
        emit(AcceptSiteErrorStates(error.toString()));
      });
    }
  }
}
