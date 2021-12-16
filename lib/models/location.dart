import 'dart:convert';

class LocationModel {
  double? longitude;
  double? latitude;
  LocationModel({
    this.longitude,
    this.latitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      longitude: map['longitude'] != null ? map['longitude'] : null,
      latitude: map['latitude'] != null ? map['latitude'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));
}
