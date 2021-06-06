import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class LocationService {
  static Future<Position> determinePosition() async {
    print("DisoverLocationServiceStatus Message: Determine position");
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    final position = await Geolocator.getCurrentPosition();
    print("DisoverLocationServiceStatus Message: GOT position");
    return position;
  }

  static Future<Address> getAddressFromPosition(Position location) async {
    final coordinates = new Coordinates(location.latitude, location.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first;
  }

  static Future<Address> getAddress() async {
    Position position = await determinePosition();
    var address = getAddressFromPosition(position);
    return address;
  }
}
