class Ticket {
  int _ticketid = 0;

  int _eventid = 0;

  int _buyerid = 0;

  Ticket();

  Ticket.fromJson(Map<String, dynamic> json) {
    _ticketid = json['ticketid'];
    _eventid = json['eventid'];
    _buyerid = json['userid'];
  }

  int getTicketID() => _ticketid;
  int getTicketEventID() => _eventid;
  int getTicketBuyerID() => _buyerid;
}
