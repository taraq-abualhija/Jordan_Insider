import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Models/user.dart';

class Coordinator extends User {
  Coordinator() : super(0, 2);
  String _phoneNum = "";

  Coordinator.fromJS(Map<String, dynamic> json, {String? newtoken})
      : super(json['userid'], 2) {
    setEmail(json['email'] ?? "");
    setPass(json['password'] ?? "null");
    setFullName(
        json['name'] ?? getEmail().substring(0, getEmail().indexOf('@')));
    super.token = newtoken ?? "";
    setImageName(json['imagename']);

    _phoneNum = json['phonenum'] ?? "";

    if (getImageName() != null) {
      setImageU8LAwait(getImageBy(getImageName()!));
    }
  }

  String getPhoneNum() => _phoneNum;
  void setPhoneNum(String pn) {
    _phoneNum = pn;
  }

  void editTicket() {}
}
