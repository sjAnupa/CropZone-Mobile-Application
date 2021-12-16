import 'dart:io';

import '../../models/estimation.dart';
import '../../models/land_info.dart';
import '../../models/location.dart';
import '../../models/media.dart';
import '../../models/media_url.dart';
import '../../models/personal_info.dart';
import '../../screens/home_screen.dart';
import '../../service/form_service.dart';
import '../../service/media_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum CurrentUploadingFile {
  IMAGE1,
  IMAGE2,
  IMAGE3,
  IMAGE4,
  IMAGE5,
  IMAGE6,
  VIDEO,
  NONE,
}

class SubmitPage extends StatefulWidget {
  final Estimation? estimation;
  final PersonalInfo? personalInfo;
  final LandInfo? landInfo;
  final LocationModel? location;
  final Media? media;
  final MediaUrl mediaUrl;
  SubmitPage({
    Key? key,
    required this.estimation,
    required this.personalInfo,
    required this.landInfo,
    required this.media,
    required this.mediaUrl,
    required this.location,
  }) : super(key: key);

  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  FormService formService = FormService();
  MediaService mediaService = MediaService();
  bool isUploading = false;
  bool isImageUploading = false;
  bool isVideoUploading = false;
  bool showSuccessIcon = false;

  void _resetAndOpenPage() {
    Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomePage()),
      ModalRoute.withName('/'),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  double? _progress;

  Future<String?> uploadFileToFirebase(
      File? file, String fileName, String fileType) async {
    String? imageUrl;
    int? timestamp = DateTime.now().millisecondsSinceEpoch;
    String uid = _auth.currentUser!.uid;
    if (file != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('media/$uid/$fileType/$timestamp$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
//////////////////////////////////////////////////////////////////////////

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          print(_progress.toString());
        });
        if (event.state == TaskState.success) {
          _progress = null;
          // Fluttertoast.showToast(msg: 'File added to the library');
        }
      }).onError((error) {
        // do something to handle error
      });

/////////////////////////////////////////////////////////

      TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => print("Completed"));
      await taskSnapshot.ref.getDownloadURL().then((value) {
        imageUrl = value;
      });
    }

    return imageUrl;
  }

  Future<void> mediaUpdate() async {
    setState(() {
      isUploading = true;
      isImageUploading = true;
    });
    if (widget.media?.photoOfNIC != null) {
      widget.personalInfo?.nicImageUrl = await uploadFileToFirebase(
          widget.media?.image1, "_photo_of_nic", "images");
    }
    if (widget.media?.photoOfDEED != null) {
      widget.landInfo?.podUrl = await uploadFileToFirebase(
          widget.media?.image1, "_photo_of_deed", "images");
    }
    if (widget.media?.image1 != null) {
      widget.mediaUrl.image1 =
          await uploadFileToFirebase(widget.media?.image1, "_image1", "images");
    }
    if (widget.media?.image2 != null) {
      widget.mediaUrl.image2 =
          await uploadFileToFirebase(widget.media?.image2, "_image2", "images");
    }
    if (widget.media?.image3 != null) {
      widget.mediaUrl.image3 =
          await uploadFileToFirebase(widget.media?.image3, "_image3", "images");
    }
    if (widget.media?.image4 != null) {
      widget.mediaUrl.image4 =
          await uploadFileToFirebase(widget.media?.image4, "_image4", "images");
    }
    if (widget.media?.image5 != null) {
      widget.mediaUrl.image5 =
          await uploadFileToFirebase(widget.media?.image5, "_image5", "images");
    }
    if (widget.media?.image6 != null) {
      widget.mediaUrl.image6 =
          await uploadFileToFirebase(widget.media?.image6, "_image6", "images");
    }
    if (widget.media?.video != null) {
      setState(() {
        isVideoUploading = true;
        isImageUploading = false;
      });
      widget.mediaUrl.video =
          await uploadFileToFirebase(widget.media?.video, "_video", "videos");
    }

    setState(() {
      isVideoUploading = false;
    });

    await formService
        .newAddForm(
      widget.estimation!,
      widget.personalInfo!,
      widget.landInfo!,
      widget.mediaUrl,
      widget.location!,
    )
        .then((value) {
      setState(() {
        isUploading = false;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  Widget uploadingProgress() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 300,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Uploading",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          if (isImageUploading)
            Column(
              children: [
                Icon(Icons.image, size: 60, color: Colors.grey[800]),
                Text(
                  "Images",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          if (isVideoUploading)
            Column(
              children: [
                Icon(Icons.video_library_outlined,
                    size: 60, color: Colors.grey[800]),
                Text(
                  "Videos",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          if (showSuccessIcon)
            Column(
              children: [
                Icon(Icons.check, size: 60, color: Colors.green[800]),
                Text(
                  "Form Submitted",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          _progress != null
              ? Container(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 5.0,
                    color: Colors.green[900],
                  ),
                )
              : Container(height: 10),
          Center(
              child: !showSuccessIcon
                  ? ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red[700])),
                      onPressed: () {
                        mediaService.uploadTask?.cancel().then((value) {
                          setState(() {
                            isVideoUploading = false;
                            isUploading = false;
                          });
                        });
                      },
                      child: Text("Cancel"),
                    )
                  : Container(height: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: !isUploading
          ? AppBar(
              title: Text("Submit"),
            )
          : AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white),
      body: !isUploading
          ? Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.fromLTRB(0, size.height * 0.2, 0, 30),
              height: size.height * 0.7,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(child: Text("Do you want to submit this form?")),
                  SizedBox(height: 30),
                  Container(
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Go back"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black54)),
                    ),
                  ),
                  Container(
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        await mediaUpdate();
                      },
                      child: Text("Submit"),
                    ),
                  ),
                  Container(
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        _resetAndOpenPage();
                      },
                      child: Text("Clear all and Cancel"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red[700])),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: uploadingProgress()),
    );
  }
}
