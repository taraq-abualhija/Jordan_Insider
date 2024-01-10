import 'dart:typed_data';

import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Shared/Constants.dart';

class ReviewUserDTO {
  String _reviewerName = "";
  String? _reviewerImagenNme;
  Uint8List? _reviewerImageU8L;
  double _reviewRate = 0;
  String? _reviewTxt;
  String _reviewDate = "";

  ReviewUserDTO();

  ReviewUserDTO.fromJSON(Map<String, dynamic> json) {
    _reviewerName = json['name'] ?? "";
    _reviewerImagenNme = json['imagename'];
    try {
      _reviewRate = double.parse(json['rating'].toString());
    } catch (e) {
      // ignore: avoid_print
      print("Error Rate is Not Double : $e");
    }

    _reviewTxt = json['reviewtxt'];
    if (json['reviewdate'] != null) {
      DateTime date = DateTime.parse(json['reviewdate']);

      _reviewDate = "${date.day}-${date.month}-${date.year}";
    }

    if (_reviewerImagenNme != null) {
      getImageBy(_reviewerImagenNme!).then((value) {
        _reviewerImageU8L = value;
      }).catchError((error) {
        logger.e(error);
      });
    }
  }

  String getReviewerName() => _reviewerName;
  Uint8List? getReviewerImage() => _reviewerImageU8L;
  double getReviewRate() => _reviewRate;
  String? getReviewTxt() => _reviewTxt;
  String getReviewDate() => _reviewDate;
}
