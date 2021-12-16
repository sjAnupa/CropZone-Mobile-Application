import 'dart:convert';

class UserData {
  String? uid;
  String? fullName;
  String? nic;
  String? email;
  String? contactNo;
  UserData({
    this.uid,
    this.fullName,
    this.nic,
    this.email,
    this.contactNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'nic': nic,
      'email': email,
      'contactNo': contactNo,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] != null ? map['uid'] : null,
      fullName: map['fullName'] != null ? map['fullName'] : null,
      nic: map['nic'] != null ? map['nic'] : null,
      email: map['email'] != null ? map['email'] : null,
      contactNo: map['contactNo'] != null ? map['contactNo'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));
}
