import 'package:jordan_insider/Models/attraction.dart';
import 'package:jordan_insider/Models/review.dart';

class Site extends Attraction {
  String _timeFrom = "";
  String _timeTo = "";
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
  void setReview(Review review) {
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
}
