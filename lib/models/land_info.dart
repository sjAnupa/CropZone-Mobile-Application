import 'dart:convert';

class LandInfo {
  String? nameOfLP;
  String? regNo;
  String? address;
  String? aol;
  String? areaOCC;
  bool? isOwnLand;
  String? podUrl;
  LandInfo({
    this.nameOfLP,
    this.regNo,
    this.address,
    this.aol,
    this.areaOCC,
    this.isOwnLand,
    this.podUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'nameOfLP': nameOfLP,
      'regNo': regNo,
      'address': address,
      'aol': aol,
      'areaOCC': areaOCC,
      'isOwnLand': isOwnLand,
      'podUrl': podUrl,
    };
  }

  factory LandInfo.fromMap(Map<String, dynamic> map) {
    return LandInfo(
      nameOfLP: map['nameOfLP'] != null ? map['nameOfLP'] : null,
      regNo: map['regNo'] != null ? map['regNo'] : null,
      address: map['address'] != null ? map['address'] : null,
      aol: map['aol'] != null ? map['aol'] : null,
      areaOCC: map['areaOCC'] != null ? map['areaOCC'] : null,
      isOwnLand: map['isOwnLand'] != null ? map['isOwnLand'] : null,
      podUrl: map['podUrl'] != null ? map['podUrl'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LandInfo.fromJson(String source) =>
      LandInfo.fromMap(json.decode(source));
}
