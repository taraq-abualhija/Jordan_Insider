// ignore_for_file: prefer_final_fields

import 'package:jordan_insider/Shared/Constants.dart';

class Review {
  String _reviewerName = "";
  String _reviewText = "";
  String? _reviewTime = "";
  double _reviewRate = 0;
  int _touristsiteId = 0;
  // ignore: unused_field
  int _reviewerId = 0;
  int _reviewid = 0;
  String siteName = "";

  Review(
    this._touristsiteId,
    this._reviewerName,
    this._reviewText,
    this._reviewTime,
    this._reviewRate,
  );

  Review.fromJSON(Map<String, dynamic> json) {
    try {
      _reviewid = json["reviewid"] ?? 0;
      _touristsiteId = json["touristsiteid"] ?? 0;
      _reviewerId = json["userid"] ?? 0;
      try {
        _reviewRate = double.parse(json["rating"].toString());
      } catch (e) {
        // ignore: avoid_print
        print("Error Rate is Not Double : $e");
      }
      _reviewText = json["reviewtxt"] ?? "";
      _reviewTime = json["reviewdate"] ?? "1-1-2024";
    } catch (e) {
      logger.e("Error in Review.fromJSON : $e");
    }
  }

  String getReviewerName() => _reviewerName;
  void setReviewerName(String reviewerName) {
    _reviewerName = reviewerName;
  }

  int getReviewID() => _reviewid;

  String getReviewText() => _reviewText;
  void setReviewText(String reviewText) {
    _reviewText = reviewText;
  }

  String? getReviewTime() => _reviewTime;
  void setReviewTime(String reviewTime) {
    _reviewTime = reviewTime;
  }

  double getReviewRate() => _reviewRate;
  void setReviewRate(double reviewRate) {
    _reviewRate = reviewRate;
  }

  int getTouristsiteId() => _touristsiteId;

  @override
  String toString() {
    String txt =
        "Name : $_reviewerName Time : $_reviewTime\nText : $_reviewText Rate : $_reviewRate";
    return txt;
  }
}
