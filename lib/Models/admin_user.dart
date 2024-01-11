import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Models/site.dart';
import 'package:jordan_insider/Models/user.dart';

class Admin extends User {
  Admin() : super(0, 1);

  Admin.fromJS(Map<String, dynamic> json, {String? newtoken})
      : super(json['userid'], 1) {
    setEmail(json['email'] ?? "");
    setPass(json['password'] ?? "null");
    setFullName(
        json['name'] ?? getEmail().substring(0, getEmail().indexOf('@')));
    super.token = newtoken ?? "";
    setImageName(json['imagename']);
    if (getImageName() != null) {
      setImageU8LAwait(getImageBy(getImageName()!));
    }
  }

  bool acceptNewSite(Site site) {
    //todo IDK
    return true;
  }
}
