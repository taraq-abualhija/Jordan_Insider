// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:jordan_insider/Controller/RestaurantCubit/restaurant_cubit.dart';
import 'package:jordan_insider/Models/restaurant.dart';
import 'package:jordan_insider/Shared/Constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class IntentUtils {
  IntentUtils._();

  static const String _apiKey = "AIzaSyC1NJOxbfFQEPPxfeJ8opJjl2083AwCQds";

  static Future<void> launchGoogleMaps({
    required double lat,
    required double long,
  }) async {
    double destinationLatitude = lat;
    double destinationLongitude = long;

    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$destinationLatitude,$destinationLongitude');

    try {
      await launchUrl(uri);
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> getLocationByName(String placeName,
      {required BuildContext context}) async {
    placeName = _removeSpecialChars(placeName);
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$placeName&key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        final lat = data['results'][0]['geometry']['location']['lat'];
        final lng = data['results'][0]['geometry']['location']['lng'];

        launchGoogleMaps(lat: lat, long: lng);
      } catch (e) {
        logger.e(e);
        MotionToast.warning(
                toastDuration: Duration(seconds: 3),
                position: MotionToastPosition.top,
                animationCurve: Curves.fastLinearToSlowEaseIn,
                title: Text("Sorry"),
                description: Text("Can't find this location"))
            .show(context);
      }
    } else {
      logger.e('Geocoding failed: ${response.statusCode}');
    }
  }

  static String _removeSpecialChars(String string) {
    return string
        .replaceAll(RegExp(r'\s'), ' ')
        .replaceAll(RegExp(r'[^A-Za-z0-9 ]+'), '')
        .replaceAllMapped(RegExp(r'(\s)\s+'), (match) => match.group(1)!)
        .trim();
  }

  static Future<Set<Restaurant>> getNearbyPlaces({
    String? type,
    double? radius,
  }) async {
    Set<Restaurant> restaurants = {};
    double latitude = 32.5343515;
    double longitude = 35.905892;
    radius ??= 1000;
    type ??= "restaurant";
    try {
      if (await Permission.location.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude = position.latitude;
        longitude = position.longitude;
        try {
          final url = Uri.parse(
              'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
              'key=$_apiKey&location=$latitude,$longitude&radius=$radius&type=$type');

          final response = await http.get(url);

          final results = jsonDecode(response.body)['results'] as List;
          for (Map ele in results) {
            restaurants.add(Restaurant.fromJson(ele));
          }
        } catch (error) {
          logger.e('Error fetching nearby places: $error');
        }
      } else {
        _getLocationPermission();
      }
    } catch (e) {
      logger.e(e);
    }

    return restaurants;
  }

  static Future<void> _getLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      RestaurantCubit.getInstans().getNearByRestaurants();
      return;
    }

    var result = await Permission.location.request();

    if (result.isGranted) {
      RestaurantCubit.getInstans().getNearByRestaurants();
    } else {}
  }
}
