import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/TicketCubit/ticket_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Models/ticket.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class TicketCubit extends Cubit<TicketStates> {
  TicketCubit() : super(TicketInitialState());

  static TicketCubit? _cubit;
  static TicketCubit getInstans() {
    _cubit ??= TicketCubit();
    return _cubit!;
  }

  List<Ticket> tickets = [];

  void getAllTickets() {
    emit(GetUserTicketLoadingState());
    String uID = UserDataCubit.getInstans().userData!.getId().toString();

    DioHelper.getData(url: GetTicketsByUserId + uID, query: {})
        .then((value) async {
      tickets.clear();
      for (var element in value.data) {
        tickets.add(Ticket.fromJson(element));

        await DioHelper.getData(
            url: GetEventById + element['eventid'].toString(),
            query: {}).then((value) {
          tickets.last.setTicketEvent(SiteEvent.fromJS(value.data));
        }).catchError((e) {});
      }
      emit(GetUserTicketSuccessState());
    }).catchError((error) {
      emit(GetUserTicketErrorState());
    });
  }

  void deleteTicket(int id) {
    emit(DeleteTicketLoadingState());
    DioHelper.deleteData(url: DeleteTicket + id.toString()).then((value) {
      tickets.removeWhere((element) => element.getTicketID() == id);
      emit(DeleteTicketSuccessState());
    }).catchError((error) {
      emit(DeleteTicketErrorState());
    });
  }
}
