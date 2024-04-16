import 'package:location/location.dart';

class LocationService {
  static makeService() async {
    var serviceEnable = await Location().serviceEnabled();
    if (!serviceEnable) {
      serviceEnable = await Location().requestService();
      if (!serviceEnable) {
        return;
      }
    }
  }

  static makePermission() async {
    var premission = await Location().hasPermission();
    if (premission == PermissionStatus.denied) {
      premission = await Location().requestPermission();
      if (premission != PermissionStatus.granted) {
        return;
      }
    }
  }
}
