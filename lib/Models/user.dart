import 'dart:typed_data';

class User {
  // ignore: prefer_final_fields
  int _id = 0;
  String _email = "";
  String _fullName = "";
  int _rollId = 3;
  String token = "";
  String? _imageName;
  Uint8List? _imageU8L;

  User(this._id, this._rollId);

  void setEmail(String email) {
    _email = email;
  }

  void setFullName(String fullName) {
    _fullName = fullName;
  }

  void setRoll(int roll) {
    _rollId = roll;
  }

  void setImageName(String? image) {
    _imageName = image;
  }

  Future<void> setImageU8LAwait(Future<Uint8List?> image) async {
    _imageU8L = await image;
  }

  void setImageU8L(Uint8List? image) {
    _imageU8L = image;
  }

  String? getImageName() => _imageName;
  Uint8List? getImageU8L() => _imageU8L;
  int getId() => _id;
  String getEmail() => _email;
  String getFullName() => _fullName;
  int getRoll() => _rollId;

  @override
  String toString() {
    return "Email : $_email | Full Name : $_fullName";
  }
}
