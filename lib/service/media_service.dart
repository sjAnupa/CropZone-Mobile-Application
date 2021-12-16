import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaService {
  // final CollectionReference _userCollection =
  //     FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UploadTask? uploadTask;
  Future<String?> uploadFileToFirebase(
      File? file, String fileName, String fileType) async {
    String? imageUrl;
    int? timestamp = DateTime.now().millisecondsSinceEpoch;
    String uid = _auth.currentUser!.uid;
    if (file != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('media/$uid/$fileType/$timestamp$fileName');
      uploadTask = firebaseStorageRef.putFile(file);

      TaskSnapshot taskSnapshot =
          await uploadTask!.whenComplete(() => print("Completed"));
      await taskSnapshot.ref.getDownloadURL().then((value) {
        imageUrl = value;
      });
    }

    return imageUrl;
  }
}
