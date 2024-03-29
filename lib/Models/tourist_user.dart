// ignore_for_file: avoid_print

import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Models/user.dart';
import 'package:jordan_insider/Models/review.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Models/ticket.dart';

class Tourist extends User {
  List<Site> _visitedSites = [];
  String _phoneNum = "";
  Set<Review> _reviews = {};
  List<Ticket> _tickets = [];
  final List<int> _favoriteSites = [];

  Tourist() : super(0, 3);

  Tourist.fromJS(Map<String, dynamic> json, {String? newtoken})
      : super(json['userid'], 3) {
    setEmail(json['email'] ?? "");
    setPass(json['password'] ?? "null");
    setFullName(
        json['name'] ?? getEmail().substring(0, getEmail().indexOf('@')));
    _phoneNum = json['phonenum'] ?? "";
    super.token = newtoken ?? "";
    setImageName(json['imagename']);
    if (getImageName() != null) {
      setImageU8LAwait(getImageBy(getImageName()!));
    }
    getFavorite(userId: getId());
  }

  void addFavorite(int id) {
    _favoriteSites.add(id);
  }

  List<int> getUserFavorite() => _favoriteSites;

  void setFavorite(List<int> f) {
    _favoriteSites.clear();
    _favoriteSites.addAll(f);
  }

  void removeFromFavorite(int id) {
    _favoriteSites.remove(id);
  }

  void setPhoneNum(String phoneNum) {
    _phoneNum = phoneNum;
  }

  String getPhoneNum() => _phoneNum;

  void addSiteToHistory(Site s) {
    _visitedSites.add(s);
  }

  void setVisitedSites(List<Site> s) {
    _visitedSites = s;
  }

  Site getHistorySiteAt(int i) {
    try {
      return _visitedSites[i];
    } catch (e) {
      print("This index isn't valid in Visited Sites!");
    }
    return _visitedSites[0];
  }

  List<Site> getVisitedSites() => _visitedSites;

  void addReview(Review review) {
    _reviews.add(review);
  }

  void setReviews(Set<Review> r) {
    _reviews = r;
  }

  Review getReviewAt(int i) {
    try {
      return _reviews.elementAt(i);
    } catch (e) {
      print("This index isn't valid in Reviews!");
    }
    return _reviews.elementAt(0);
  }

  Set<Review> getReviews() => _reviews;

  void addNewTicket(Ticket t) {
    _tickets.add(t);
  }

  void setTickets(List<Ticket> t) {
    _tickets = t;
  }

  List<Ticket> getTicket() => _tickets;
}
