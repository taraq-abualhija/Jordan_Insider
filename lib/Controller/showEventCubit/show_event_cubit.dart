// ignore_for_file: avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/showEventCubit/show_event_state.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class ShowEventCubit extends Cubit<ShowEventStates> {
  ShowEventCubit() : super(ShowEventInitialStates());
  static ShowEventCubit? _cubit;

  static ShowEventCubit getInstans() {
    _cubit ??= ShowEventCubit();
    return _cubit!;
  }

  List<SiteEvent> events = [];
  List<SiteEvent> coorEvents = [];
  int editEventIndex = -1;
  int wantedEventID = -1;

  int getEditEventIndex() {
    int temp = editEventIndex;
    editEventIndex = -1;
    return temp;
  }

  void setwantedEventID(int iD) {
    wantedEventID = iD;
  }

  SiteEvent? getwantedEventID() {
    if (wantedEventID >= 0) {
      int temp = wantedEventID;
      wantedEventID = -1;
      return events.where((element) {
        return element.getID() == temp;
      }).first;
      // return getSiteByID(wantedSiteID);
    }
    wantedEventID = -1;
    return null;
  }

  SiteEvent? getEventByID(int iD) {
    emit(ShowEventLoadingStates());

    String url = GetEventById + iD.toString();
    SiteEvent? event;
    DioHelper.getData(url: url, query: {}).then((value) async {
      if (value.data != null) {
        event = SiteEvent.fromJS(value.data);

        //$ Search for this Site in the list of all sites
        for (var element in events) {
          if (element.getID() == event!.getID()) {
            //$ Remove old site from the list
            events.remove(element);
            //$ Add the new site to the list
            events.add(event!);
          }
        }
        logger.e(event.toString());
        emit(GetEventByIDSuccessStates());
        return event;
      } else {
        emit(ShowEventErrorStates("Wrong ID : $iD"));
      }
    }).catchError((error) {
      emit(ShowEventErrorStates(error));
      return null;
    });
    return event;
  }

  Future<void> getAllEvents({int? id}) async {
    coorEvents.clear();
    events.clear();

    DioHelper.getData(
      url: GetAllEvents,
      query: {},
    ).then((value) async {
      events.clear();
      for (var element in value.data) {
        SiteEvent s = SiteEvent.fromJS(element);
        if (id == null) {
          try {
            events.add(s);
          } catch (e) {
            logger.e(e);
          }
        } else {
          print("${s.getCoordinatorid()} : ${s.getName()}");
          print(id);
          print("------------------------");
          if (s.getCoordinatorid() == id) {
            coorEvents.add(s);
          }
        }
      }
      emit(GetEventSuccessStates());
      await Future.delayed(Duration(seconds: 3));
      emit(ShowEventInitialStates());
    }).catchError((error) async {
      emit(ShowEventErrorStates(error.toString()));
      logger.e(error);
    });
  }

  void setMyEvents(int id) {
    coorEvents.clear();
    for (var element in events) {
      if (element.getCoordinatorid() == id) {
        coorEvents.add(element);
      }
    }
  }

  void deleteSite(int iD) {
    String url = DeleteEvent + iD.toString();
    DioHelper.deleteData(url: url).then((value) {
      emit(ShowEventSuccessStates());
      try {
        events.where((element) {
          return element.getID() == iD;
        });
        coorEvents.where((element) {
          return element.getID() == iD;
        });
      } catch (e) {
        e;
      }
    }).catchError((error) {
      logger.e(error);
      emit(ShowEventErrorStates(error));
    });
  }

  void justEmitInit() {
    emit(ShowEventInitialStates());
  }
}
