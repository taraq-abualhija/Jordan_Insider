import 'dart:typed_data';
import 'package:jordan_insider/Controller/controller.dart';
import 'package:jordan_insider/Shared/Constants.dart';

class Attraction {
  int id = 0;
  String name = "";
  String description = "";
  final List<String?> imagesName = [];
  final List<Uint8List?> images = [];
  String validity = "";
  String location = "";
  int coordinatorid = 0;

  int getID() => id;

  String getName() => name;
  void setName(String newName) {
    name = newName;
  }

  String getLocation() => location;
  void setLocation(String location) {
    this.location = location;
  }

  String getDescription() => description;
  void setDescription(String description) {
    this.description = description;
  }

  String getValidity() => validity;

  void addImage(Uint8List imageByte) {
    images.add(imageByte);
  }

  int getCoordinatorid() => coordinatorid;
  void setCoordinatorid(int id) {
    coordinatorid = id;
  }

  List<String?> getImagesNames() => imagesName;

  List<Uint8List?> getImages() => images;

  void getAllImages() async {
    for (var element in imagesName) {
      if (element != null) {
        var image = await getImageBy(element);
        if (image != null) {
          images.add(image);
        }
      }
    }
    logger.t("End of _getAllImages");
  }

  @override
  String toString() {
    return "ID : $id | Name : $name | Location : $location | ";
  }
}
