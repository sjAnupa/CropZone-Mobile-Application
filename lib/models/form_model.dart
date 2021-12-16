import 'dart:convert';

import '../../models/estimation.dart';
import '../../models/land_info.dart';
import '../../models/media_url.dart';
import '../../models/personal_info.dart';

class FormModel {
  String? formId;
  Estimation? estimation;
  LandInfo? landInfo;
  PersonalInfo? personalInfo;
  MediaUrl? media;
  DateTime? addedDate;
  String? status;

  FormModel({
    this.formId,
    this.estimation,
    this.landInfo,
    this.personalInfo,
    this.media,
    this.addedDate,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'formId': formId,
      'estimation': estimation?.toMap(),
      'landInfo': landInfo?.toMap(),
      'personalInfo': personalInfo?.toMap(),
      'media': media?.toMap(),
      'addedDate': addedDate?.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(
      formId: map['formId'] != null ? map['formId'] : null,
      estimation: map['estimation'] != null
          ? Estimation.fromMap(map['estimation'])
          : null,
      landInfo:
          map['landInfo'] != null ? LandInfo.fromMap(map['landInfo']) : null,
      personalInfo: map['personalInfo'] != null
          ? PersonalInfo.fromMap(map['personalInfo'])
          : null,
      media: map['media'] != null ? MediaUrl.fromMap(map['media']) : null,
      addedDate: map['addedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['addedDate'])
          : null,
      status: map['status'] != null ? map['status'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormModel.fromJson(String source) =>
      FormModel.fromMap(json.decode(source));
}
