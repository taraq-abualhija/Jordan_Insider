import 'dart:math';

import 'package:jordan_insider/Shared/Constants.dart';

class Restaurant {
  String _name = "";
  double _locLat = 0;
  double _locLng = 0;
  double _rate = 0;
  int _usersRate = 0;
  String _networkImage = "";

  Restaurant.fromJson(Map json) {
    try {
      _name = json['name'] ?? "";
      _locLat = double.parse(json['geometry']['location']['lat'].toString());
      _locLng = double.parse(json['geometry']['location']['lng'].toString());

      _rate = double.parse(json['rating'].toString() != "null"
          ? json['rating'].toString()
          : "0");
      _usersRate = int.parse(json['user_ratings_total'].toString() != "null"
          ? json['user_ratings_total'].toString()
          : "0");

      if (json['photos'] != null) {
        List photos = json['photos'];

        int randomIndex = Random().nextInt(photos.length);
        _networkImage =
            "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyC1NJOxbfFQEPPxfeJ8opJjl2083AwCQds&photoreference=${json['photos'][randomIndex]['photo_reference']}&maxwidth=400";
      }
    } catch (e) {
      // ignore: avoid_print
      print(_name);
      logger.e(e);
    }
  }

// Setters
  void setName(String newName) {
    _name = newName;
  }

  void setLocLat(double newLocLat) {
    _locLat = newLocLat;
  }

  void setLocLng(double newLocLng) {
    _locLng = newLocLng;
  }

  void setRate(double newRate) {
    _rate = newRate;
  }

  void setUsersRate(int newUsersRate) {
    _usersRate = newUsersRate;
  }

  void setNetworkImage(String newNetworkImage) {
    _networkImage = newNetworkImage;
  }

  // Getters
  String getName() => _name;
  double getLocLat() => _locLat;
  double getLocLng() => _locLng;
  double getRate() => _rate;
  int getUsersRate() => _usersRate;
  String getNetworkImage() => _networkImage;

  @override
  String toString() {
    return "Name : $_name | Lat : $_locLat , Lng : $_locLng";
  }
}
