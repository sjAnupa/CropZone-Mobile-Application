import 'dart:io';
import '../../models/media.dart';
import '../../models/personal_info.dart';
import '../../screens/constant.dart';
import '../../service/media_service.dart';
import '../../widgets/select_media.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInformation extends StatefulWidget {
  final PersonalInfo? personalInfo;
  final Media media;
  final Function increasePageNumber;
  const PersonalInformation({
    Key? key,
    this.personalInfo,
    required this.increasePageNumber,
    required this.media,
  }) : super(key: key);

  @override
  _PersonalInformationState createState() =>
      _PersonalInformationState(this.personalInfo);
}

class _PersonalInformationState extends State<PersonalInformation> {
  _PersonalInformationState(PersonalInfo? personalInfo);

  ImagePicker _imagePicker = ImagePicker();
  bool uploading = false;
  bool? isImagePicked = false;
  String? imageUrl;
  MediaService mediaService = MediaService();
  final _formKey = GlobalKey<FormState>();

  Future<void> pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    File? file;
    if (image != null) {
      file = File(image.path);
      isImagePicked = true;
    }
    setState(() {
      widget.media.photoOfNIC = file;
    });
  }

  void removeImage() {
    setState(() {
      widget.media.photoOfNIC = null;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.increasePageNumber(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              padding: EdgeInsets.fromLTRB(10, 30, 10, 40),
              margin: EdgeInsets.fromLTRB(10, 20, 10, 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Text(
                            "සම්පූර්ණ නම",
                            style: TextStyle(fontSize: 16),
                          ))),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: TextFormField(
                              initialValue: widget.personalInfo?.fullName,
                              onChanged: (val) {
                                widget.personalInfo?.fullName = val;
                              },
                              decoration: inputDecoration,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                if (value.length < 4) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "ජා. හැදුනුම්පත",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.personalInfo?.nic,
                            onChanged: (value) {
                              widget.personalInfo?.nic = value;
                            },
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter NIC number");
                              } else if (!(value.length > 9)) {
                                return "Please Enter a valid NIC card number";
                              } else {
                                try {
                                  int.parse(value.toString().substring(0, 9));
                                } catch (e) {
                                  return "Please Enter a valid NIC";
                                }
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Text(
                            "ලිපිනය",
                            style: TextStyle(fontSize: 16),
                          ))),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.personalInfo?.address,
                            onChanged: (value) {
                              widget.personalInfo?.address = value;
                            },
                            maxLines: 3,
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Text(
                            "ග්‍රාමනිලධාරී වසම",
                            style: TextStyle(fontSize: 15),
                          ))),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.personalInfo?.gnd,
                            onChanged: (value) {
                              widget.personalInfo?.gnd = value;
                            },
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'You must fill this field';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "ජා. හැදුනුම්පතෙහි ඡායාරූපය",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 50),
                        child: selectLargeImage(
                          pickImage,
                          size,
                          widget.media.photoOfNIC,
                          removeImage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 30,
              top: 12,
              child: Container(
                padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                color: Colors.white,
                child: Text(
                  'Personal information',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
