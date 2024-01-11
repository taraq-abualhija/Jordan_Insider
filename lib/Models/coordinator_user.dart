// ignore_for_file: avoid_print

import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Models/ticket.dart';
import 'package:jordan_insider/Models/user.dart';

class Coordinator extends User {
  List<Ticket> _tickets = [];
  Coordinator() : super(0, 2);
  String _phoneNum = "";

  Coordinator.fromJS(Map<String, dynamic> json, {String? newtoken})
      : super(json['userid'], 2) {
    setEmail(json['email'] ?? "");
    setPass(json['password'] ?? "null");
    setFullName(
        json['name'] ?? getEmail().substring(0, getEmail().indexOf('@')));
    super.token = newtoken ?? "";
    setImageName(json['imagename']);

    _phoneNum = json['phonenum'] ?? "";

    if (getImageName() != null) {
      setImageU8LAwait(getImageBy(getImageName()!));
    }
  }
  void addNewTicket(Ticket t) {
    _tickets.add(t);
  }

  void setTickets(List<Ticket> t) {
    _tickets = t;
  }

  Ticket getTicketAt(int i) {
    try {
      return _tickets[i];
    } catch (e) {
      print("This index isn't valid in Visited Sites!");
    }
    return _tickets[0];
  }

  String getPhoneNum() => _phoneNum;
  void setPhoneNum(String pn) {
    _phoneNum = pn;
  }

  List<Ticket> getTicket() => _tickets;

  void deleteTicket(Ticket ticket) {
    // ignore: list_remove_unrelated_type
    _tickets.remove(ticket.getID());
  }

  void editTicket() {}
}
