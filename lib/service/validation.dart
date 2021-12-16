import '../../models/estimation.dart';
import '../../models/land_info.dart';
import '../../models/media.dart';
import '../../models/personal_info.dart';
import 'package:cropzone/widgets/alerts.dart';
import 'package:flutter/cupertino.dart';

class Validation {
  bool? validateForm(PersonalInfo personalInfo, LandInfo landInfo,
      Estimation estimation, BuildContext context) {
    if ((personalInfo.fullName == null) ||
        (personalInfo.address == null) ||
        (personalInfo.gnd == null) ||
        (personalInfo.nic == null) ||
        validateNic(personalInfo.nic) == false) {
      displayDialog(context,
          "You must fill in all fields properly in personal information form");
      return false;
    } else if ((landInfo.address == null) ||
        (landInfo.aol == null) ||
        (landInfo.areaOCC == null) ||
        (landInfo.nameOfLP == null) ||
        (landInfo.regNo == null)) {
      displayDialog(context,
          "You must fill in all of the fields in land information form");
      return false;
    } else if ((estimation.causeOfDamage == null) ||
        (estimation.comment == null) ||
        (estimation.crop == null) ||
        (estimation.damagedAres == null) ||
        (estimation.expectedYPI == null) ||
        (estimation.incidentDate == null) ||
        (estimation.yieldEM == null) ||
        (estimation.yourEstDmg == null)) {
      displayDialog(
          context, "You must fill in all of the fields in Estimation form");
      return false;
    } else {
      return true;
    }
  }

  bool? validateMedia(Media media, BuildContext context) {
    if (media.photoOfNIC == null) {
      displayDialog(context, "Please upload a photo of your NIC");
      return false;
    } else if (media.photoOfDEED == null) {
      displayDialog(
          context, "Please upload Photo of Deed in Land information form");
      return false;
    } else if ((media.image1 == null) ||
        (media.image2 == null) ||
        (media.image3 == null)) {
      displayDialog(context, "Please upload at least 3 images");
      return false;
    } else if (media.video == null) {
      displayDialog(context, "Please upload a video of the crop area");
      return false;
    } else {
      return true;
    }
  }

  bool? validateNic(String? value) {
    try {
      int.parse(value.toString().substring(0, 9));
    } catch (e) {
      return false;
    }

    if (value!.isEmpty) {
      return false;
    } else if (!(value.length > 9)) {
      return false;
    }

    return true;
  }
}
