import 'dart:convert';

class Estimation {
  String? crop;
  String? causeOfDamage;
  String? incidentDate;
  String? expectedYPI;
  String? yieldEM;
  String? damagedAres;
  String? yourEstDmg;
  String? comment;
  Estimation(
      {this.crop,
      this.causeOfDamage,
      this.incidentDate,
      this.expectedYPI,
      this.yieldEM,
      this.damagedAres,
      this.yourEstDmg,
      this.comment});

  Map<String, dynamic> toMap() {
    return {
      'crop': crop,
      'causeOfDamage': causeOfDamage,
      'incidentDate': incidentDate,
      'expectedYPI': expectedYPI,
      'yieldEM': yieldEM,
      'damagedAres': damagedAres,
      'yourEstDmg': yourEstDmg,
      'comment': comment,
    };
  }

  factory Estimation.fromMap(Map<String, dynamic> map) {
    return Estimation(
      crop: map['crop'] != null ? map['crop'] : null,
      causeOfDamage: map['causeOfDamage'] != null ? map['causeOfDamage'] : null,
      incidentDate: map['incidentDate'] != null ? map['incidentDate'] : null,
      expectedYPI: map['expectedYPI'] != null ? map['expectedYPI'] : null,
      yieldEM: map['yieldEM'] != null ? map['yieldEM'] : null,
      damagedAres: map['damagedAres'] != null ? map['damagedAres'] : null,
      yourEstDmg: map['yourEstDmg'] != null ? map['yourEstDmg'] : null,
      comment: map['comment'] != null ? map['comment'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Estimation.fromJson(String source) =>
      Estimation.fromMap(json.decode(source));
}
