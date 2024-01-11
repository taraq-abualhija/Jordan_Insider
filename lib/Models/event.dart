import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/ticket.dart';

class SiteEvent extends Attraction {
  String _dateStart = "";
  final List<Ticket?> _tickets = [];
  double _price = 0;

  SiteEvent();

  SiteEvent.fromJS(Map<String, dynamic> json) {
    name = json['name'] ?? "null";
    id = json['eventid'] ?? 0;
    coordinatorid = json['coordinatoorid'] ?? 0;
    _dateStart = json['datestart'] ?? "null";
    validity = json['validity'] ?? "null";
    description = json['details'] ?? "";
    location = json['location'] ?? "";
    imagesName.add(json['image1']);
    imagesName.add(json['image2']);
    try {
      _price = double.parse(json["price"].toString());
    } catch (e) {
      e;
    }
    getAllImages();
  }

  String getStartDate() => _dateStart;
  void setStartDate(String newDate) {
    _dateStart = newDate;
  }

  double getPrice() => _price;
  void setPrice(double price) {
    _price = price;
  }

  List<Ticket?> getTickets() => _tickets;
}
