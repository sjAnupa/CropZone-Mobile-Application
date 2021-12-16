import 'dart:convert';

import '../../models/location.dart';

class MediaUrl {
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  String? image6;
  String? video;
  LocationModel? location;
  MediaUrl({
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.image6,
    this.video,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
      'image5': image5,
      'image6': image6,
      'video': video,
      'location': location?.toMap(),
    };
  }

  factory MediaUrl.fromMap(Map<String, dynamic> map) {
    return MediaUrl(
      image1: map['image1'] != null ? map['image1'] : null,
      image2: map['image2'] != null ? map['image2'] : null,
      image3: map['image3'] != null ? map['image3'] : null,
      image4: map['image4'] != null ? map['image4'] : null,
      image5: map['image5'] != null ? map['image5'] : null,
      image6: map['image6'] != null ? map['image6'] : null,
      video: map['video'] != null ? map['video'] : null,
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaUrl.fromJson(String source) =>
      MediaUrl.fromMap(json.decode(source));
}
