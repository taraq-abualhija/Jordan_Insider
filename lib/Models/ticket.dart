import 'package:jordan_insider/Models/event.dart';

class Ticket {
  int _ticketid = 0;
  int _eventid = 0;
  int _buyerid = 0;
  SiteEvent? _event;

  Ticket();

  Ticket.fromJson(Map<String, dynamic> json) {
    _ticketid = json['ticketid'];
    _eventid = json['eventid'];
    _buyerid = json['userid'];
  }

  int getTicketID() => _ticketid;
  int getTicketEventID() => _eventid;
  int getTicketBuyerID() => _buyerid;
  void setTicketEvent(SiteEvent event) {
    _event = event;
  }

  SiteEvent? getEvent() => _event;
}
