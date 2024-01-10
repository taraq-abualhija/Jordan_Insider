import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/review.dart';

class Site extends Attraction {
  String _timeFrom = "00:00";
  String _timeTo = "00:00";
  final List<Review> _reviews = [];
  String _status = "pending";

  Site();

  //Named Constructor
  Site.fromJSON(Map<String, dynamic> json) {
    id = json['touristsiteid'] ?? 0;
    coordinatorid = json['coordinatorid'] ?? 0;
    name = json['name'] ?? "null";
    description = json['description'] ?? "null";
    location = json['location'] ?? "null";
    _timeFrom = json['tfrom'] ?? "00:00";
    _timeTo = json['tto'] ?? "00:00";
    _status = json['status'] ?? "pending";
    imagesName.add(json['image1']);
    imagesName.add(json['image2']);
    imagesName.add(json['image3']);
    imagesName.add(json['image4']);
    getAllImages();
    // _reviews = json['reviews']; //!Error
  }

  String getTimeFrom() => _timeFrom;
  void setTimeFrom(String time) {
    _timeFrom = time;
  }

  String getStatus() => _status;
  void setStatus(String status) {
    _status = status;
  }

  String getTimeTo() => _timeTo;
  void setTimeTo(String time) {
    _timeTo = time;
  }

  List<Review?> getReviews() => _reviews;
  void addReview(Review review) {
    _reviews.add(review);
  }

  double getAvgRate() {
    if (_reviews.isEmpty) {
      return 0;
    }
    double sum = 0;
    for (var review in _reviews) {
      sum += review.getReviewRate();
    }
    return sum / _reviews.length;
  }

  bool isOpen() {
    if (_timeFrom == "00:00" && _timeTo == "00:00") {
      return true;
    }

    DateTime dateFrom = stringToDate(_timeFrom);
    DateTime dateTo = stringToDate(_timeTo);

    DateTime now = DateTime.now();

    if (!now.difference(dateFrom).isNegative &&
        now.difference(dateTo).isNegative) {
      return true;
    }

    return false;
  }

  DateTime stringToDate(String time) {
    int h = 0;
    int m = 0;
    String pmAm = "";
    h = int.parse(time.substring(0, time.indexOf(':')));
    m = int.parse(time.substring(time.indexOf(':') + 1, time.indexOf(' ')));
    pmAm = time.substring(time.indexOf(' ') + 1);
    if (pmAm == "PM") {
      h += 12;
    }
    DateTime date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      h,
      m,
    );
    return date;
  }
}
