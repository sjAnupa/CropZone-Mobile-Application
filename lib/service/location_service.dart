import '../../widgets/alerts.dart';
import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

// class LocationService {
//   Future<Position> determinePosition(BuildContext context) async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       // displayDialog(context, "Please enable the location service");
//       // return Future.error("Location Service Disabled");
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         displayDialog(context, "Please give permission for location service");
//         // return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       displayDialog(context,
//           'Location permissions are permanently denied, we cannot request permissions.');
//       // return Future.error(
//       //     'Location permissions are permanently denied, we cannot request permissions.');

//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition();

//   }
// }

class LocationService {
  Location location = new Location();

  Future<LocationData> getLocation(BuildContext context) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          displayDialog(context, "Please give permission for location service");
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          displayDialog(context,
              'Please give permission for location service for continue');
        }
      }
    } catch (e) {}

    _locationData = await location.getLocation();
    return _locationData;
  }
}
