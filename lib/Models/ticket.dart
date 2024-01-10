import 'package:jordan_insider/Models/coordinator_user.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Models/tourist_user.dart';

class Ticket {
  late int _ticketid;
  Coordinator? _coordinator;
  late final Site? _site;
  late final SiteEvent? _event;
  late double _price;
  late bool _validity;
  final List<Tourist> _buyers = [];

  Ticket();

  Ticket.fromJS(Map<String, dynamic> json) {
    _ticketid = json['ticketid'];
    _coordinator = json['coordinator'];
    _site = json['site'];
    _event = json['event'];
    _price = json['price'] ?? "";
    _validity = json['validity'];

    // _reviews = json['reviews']; //!Error
  }

  int getID() => _ticketid;

  Site? getSite() => _site;

  SiteEvent? getEvent() => _event;

  Coordinator? getCoordinator() => _coordinator;

  void setPrice(double price) {
    _price = price;
  }

  double getPrice() => _price;

  void setValidity(bool valid) {
    _validity = valid;
  }

  bool getValidity() => _validity;

  void addBuyer(Tourist buyer) {
    _buyers.add(buyer);
  }

  List<Tourist> getBuyers() => _buyers;
}
