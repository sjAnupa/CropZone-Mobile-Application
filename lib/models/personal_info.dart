import 'dart:convert';

class PersonalInfo {
  String? fullName;
  String? nic;
  String? address;
  String? gnd;
  String? nicImageUrl;
  PersonalInfo(
      {this.fullName, this.nic, this.address, this.gnd, this.nicImageUrl});

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'nic': nic,
      'address': address,
      'gnd': gnd,
      'nicImageUrl': nicImageUrl,
    };
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      fullName: map['fullName'],
      nic: map['nic'],
      address: map['address'],
      gnd: map['gnd'],
      nicImageUrl: map['nicImageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalInfo.fromJson(String source) =>
      PersonalInfo.fromMap(json.decode(source));
}
