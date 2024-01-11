// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class IntentUtils {
  IntentUtils._();

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
      print(e);
    }
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // } else {
    //   logger.e('An error occurred');
    // }
  }

  static Future<void> getLocationByName(String placeName,
      {required BuildContext context}) async {
    placeName = _removeSpecialChars(placeName);
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$placeName&key=AIzaSyC1NJOxbfFQEPPxfeJ8opJjl2083AwCQds');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        final lat = data['results'][0]['geometry']['location']['lat'];
        final lng = data['results'][0]['geometry']['location']['lng'];

        launchGoogleMaps(lat: lat, long: lng);
      } catch (e) {
        print(e);
        MotionToast.warning(
                toastDuration: Duration(seconds: 3),
                position: MotionToastPosition.top,
                animationCurve: Curves.fastLinearToSlowEaseIn,
                title: Text("Sorry"),
                description: Text("Can't find this location"))
            .show(context);
      }
    } else {
      print('Geocoding failed: ${response.statusCode}');
    }
  }

  static String _removeSpecialChars(String string) {
    return string
        .replaceAll(RegExp(r'\s'), ' ')
        .replaceAll(RegExp(r'[^A-Za-z0-9 ]+'), '')
        .replaceAllMapped(RegExp(r'(\s)\s+'), (match) => match.group(1)!)
        .trim();
  }
}
