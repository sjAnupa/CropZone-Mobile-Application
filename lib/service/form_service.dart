import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/estimation.dart';
import '../../models/form_model.dart';
import '../../models/land_info.dart';
import '../../models/location.dart';
import '../../models/media_url.dart';
import '../../models/personal_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FormService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth _auth = FirebaseAuth.instance;

  List<FormModel> newFormModelList = [];
  // Future<void> fetchData() async {
  //   formDataList = [];
  //   final formData = await _userCollection.doc(_auth.currentUser!.uid).get();
  //   List userData = [];
  //   try {
  //     userData = await formData.get('FormData');
  //   } catch (e) {
  //     print(e);
  //   }
  //   if (userData.isNotEmpty) {
  //     userData.forEach((e) {
  //       formDataList.add(e);
  //       formModelList.add(FormModel.fromMap(e));
  //     });
  //   }

  //   // print("FORM OBJECT LIST $formDataList");
  // }

  // Future<void> saveForm(Estimation estimation, PersonalInfo personalInfo,
  //     LandInfo landInfo, MediaUrl media, LocationModel location) async {
  //   await fetchData();
  //   Uuid uuid = Uuid();
  //   String uid = _auth.currentUser!.uid;
  //   FormModel? formModel = FormModel();
  //   formModel.formId = uuid.v1();
  //   formModel.estimation = estimation;
  //   media.location = location;
  //   formModel.media = media;

  //   formModel.personalInfo = personalInfo;
  //   formModel.landInfo = landInfo;
  //   formModel.status = 'Pending';
  //   formModel.addedDate = DateTime.now();
  //   formDataList.add(formModel.toMap());

  //   Map<String, dynamic> form = {
  //     "FormData": formDataList,
  //   };
  //   await _userCollection.doc(uid).update(form);
  // }

  Future<void> newAddForm(Estimation estimation, PersonalInfo personalInfo,
      LandInfo landInfo, MediaUrl media, LocationModel location) async {
    String uid = _auth.currentUser!.uid;
    Uuid uuid = Uuid();
    FormModel? formModel = FormModel();
    String? formId = uuid.v1();
    formModel.formId = formId;
    formModel.estimation = estimation;
    media.location = location;
    formModel.media = media;
    formModel.personalInfo = personalInfo;
    formModel.landInfo = landInfo;
    formModel.status = 'Pending';
    formModel.addedDate = DateTime.now();
    Map<String, dynamic> form = formModel.toMap();

    await _userCollection.doc(uid).collection("forms").doc(formId).set(form);
  }

  Future<void> newFetchForm() async {
    newFormModelList = [];
    await _userCollection
        .doc(_auth.currentUser!.uid)
        .collection("forms")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                newFormModelList.add(FormModel.fromMap(element.data()));
              })
            });
  }
}
