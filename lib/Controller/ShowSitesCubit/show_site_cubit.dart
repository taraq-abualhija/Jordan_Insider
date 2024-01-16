// ignore_for_file: avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/ShowSitesCubit/show_site_state.dart';
import 'package:jordan_insider/Models/coordinator_user.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/cardcreate.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class ShowSiteCubit extends Cubit<ShowSiteStates> {
  ShowSiteCubit() : super(ShowSiteInitialStates());
  static ShowSiteCubit? _cubit;

  static ShowSiteCubit getInstans() {
    _cubit ??= ShowSiteCubit();
    return _cubit!;
  }

  List<Site> allSites = [];
  List<Site> acceptedSites = [];
  List<Site> pendingSites = [];
  List<Site> coorSite = [];

  SortRestaurantBy dropdownValue = SortRestaurantBy.distance;
  void changeDropdownValue(String? val) {
    emit(ShowSiteInitialStates());
    switch (val) {
      case "name":
        dropdownValue = SortRestaurantBy.name;
        break;
      case "rate":
        dropdownValue = SortRestaurantBy.rate;
        break;
      default:
        dropdownValue = SortRestaurantBy.distance;
    }
    emit(ChangeDropdownValueStates());
  }

  int editSiteIndex = -1;
  int wantedSiteID = -1;

  int getEditSiteIndex() {
    int temp = editSiteIndex;
    editSiteIndex = -1;
    return temp;
  }

  void setwantedSiteID(int iD) {
    wantedSiteID = iD;
  }

  Site? getwantedSiteID() {
    if (wantedSiteID >= 0) {
      int temp = wantedSiteID;
      wantedSiteID = -1;
      return acceptedSites.where((element) {
        return element.getID() == temp;
      }).first;
      // return getSiteByID(wantedSiteID);
    }
    wantedSiteID = -1;
    return null;
  }

  Future<Site?> getSiteByID(int iD) async {
    emit(ShowSiteLoadingStates());

    String url = GetTouristSiteById + iD.toString();
    Site? site;
    await DioHelper.getData(url: url, query: {}).then((value) async {
      if (value.data != null) {
        site = Site.fromJSON(value.data);

        //$ Search for this Site in the list of all sites
        for (var element in allSites) {
          if (element.getID() == site!.getID()) {
            //$ Remove old site from the list
            allSites.remove(element);
            //$ Add the new site to the list
            allSites.add(site!);
            _splitSite(site!);
          }
        }
        logger.e(site.toString());
        emit(GetSiteByIDSuccessStates());
        return site;
      } else {
        emit(ShowSiteErrorStates("Wrong ID : $iD"));
      }
    }).catchError((error) {
      emit(ShowSiteErrorStates(error));
      return null;
    });
    return site;
  }

  Future<void> getAllSites({int? id}) async {
    DioHelper.getData(
      url: GetAllTouristSites,
      query: {},
    ).then((value) async {
      acceptedSites.clear();
      pendingSites.clear();
      allSites.clear();
      for (var element in value.data) {
        try {
          var s = Site.fromJSON(element);
          allSites.add(s);
          await getSiteReviewById(s.getID());
          _splitSite(s);
        } catch (e) {
          logger.e(e);
        }
      }
      if (id != null) {
        setMySites(id);
      }
      emit(GetSiteSuccessStates());
      await Future.delayed(Duration(seconds: 3));
      emit(ShowSiteInitialStates());
    }).catchError((error) async {
      emit(ShowSiteErrorStates(error.toString()));
      logger.e(error);
    });
  }

  Future<void> getSiteReviewById(int id) async {
    await DioHelper.getData(
      url: GetReviewsByTouristSiteId + id.toString(),
      query: {},
    ).then((value) {
      //List<Map>
      for (var element in value.data) {
        //Map
        allSites
            .where((element) {
              return element.getID() == id;
            })
            .first
            .addReview(Review.fromJSON(element));
      }
    }).catchError((error) {});
  }

  void setMySites(int id) {
    coorSite.clear();
    for (var element in acceptedSites) {
      if (element.getCoordinatorid() == id) {
        coorSite.add(element);
      }
    }
    for (var element in pendingSites) {
      if (element.getCoordinatorid() == id) {
        coorSite.add(element);
      }
    }
  }

  void deleteSite(int iD) {
    String url = DeleteTouristSite + iD.toString();
    DioHelper.deleteData(url: url).then((value) {
      emit(ShowSiteSuccessStates());
      allSites.where((element) {
        return element.getID() == iD;
      });

      coorSite.where((element) {
        return element.getID() == iD;
      });

      try {
        acceptedSites.where((element) {
          return element.getID() == iD;
        });
      } catch (e) {
        e;
      }
      try {
        pendingSites.where((element) {
          return element.getID() == iD;
        });
      } catch (e) {
        e;
      }
    }).catchError((error) {
      logger.e(error);
      emit(ShowSiteErrorStates(error));
    });
  }

  void justEmitInit() {
    emit(ShowSiteInitialStates());
  }

  void _splitSite(Site site) {
    getCoorBySite(site);
    if (site.getStatus() == "Accepted") {
      acceptedSites.add(site);
    } else {
      pendingSites.add(site);
    }
  }

  Map<Site, Coordinator> siteCoorMap = {};

  void getCoorBySite(Site site) {
    String coorId = site.getCoordinatorid().toString();
    DioHelper.getData(url: GetUserById + coorId, query: {}).then((value) {
      if (value.data["roleid"] == 2) {
        Coordinator user = Coordinator.fromJS(value.data);

        siteCoorMap.addAll({site: user});
      }
    }).catchError((error) {});
  }
}
