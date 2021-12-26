import 'dart:io';

import '../../models/land_info.dart';
import '../../models/media.dart';
import '../../service/media_service.dart';
import '../../widgets/select_media.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';

class LandInformation extends StatefulWidget {
  final LandInfo? landInformation;
  final Function increasePageNumber;
  final Media media;
  LandInformation({
    Key? key,
    required this.landInformation,
    required this.increasePageNumber,
    required this.media,
  }) : super(key: key);

  @override
  _LandInformationState createState() => _LandInformationState();
}

class _LandInformationState extends State<LandInformation> {
  ImagePicker _imagePicker = ImagePicker();

  bool? isImagePicked = false;
  String? imageUrl;
  MediaService mediaService = MediaService();
  final _formKey = GlobalKey<FormState>();

  //Upload image to firebase storage

  Future<void> pickDeedImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    File? file;
    if (image != null) {
      file = File(image.path);
      isImagePicked = true;
    }
    setState(() {
      widget.media.photoOfDEED = file;
    });
  }

  void removeImage() {
    setState(() {
      widget.media.photoOfDEED = null;
    });
  }

  @override
  void initState() {
    widget.increasePageNumber(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "වගා ඉඩම් කොටසෙහි නම",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.landInformation?.nameOfLP,
                            onChanged: (value) {
                              widget.landInformation?.nameOfLP = value;
                            },
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Name of the plot';
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
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "ලියාපදිංචි අංකය",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.landInformation?.regNo,
                            onChanged: (value) {
                              widget.landInformation?.regNo = value;
                            },
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Reg Number';
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
                            "ඉඩමෙහි ලිපිනය",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.landInformation?.address,
                            onChanged: (value) {
                              widget.landInformation?.address = value;
                            },
                            maxLines: 3,
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Address';
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
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "ඉඩමෙහි වපසරිය\n(අක්කර)",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.landInformation?.aol,
                            onChanged: (value) {
                              widget.landInformation?.aol = value;
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
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "වගා කර ඇති ඉඩම් කොටසේ ප්‍රමාණය\n(අක්කර)",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.landInformation?.areaOCC,
                            onChanged: (value) {
                              widget.landInformation?.areaOCC = value;
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
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "ඉඩමෙහි අයිතිකාරිත්වට මට හිමිය",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Checkbox(
                            checkColor: Colors.white,
                            value: widget.landInformation?.isOwnLand ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null) {
                                  widget.landInformation?.isOwnLand = value;
                                } else {
                                  widget.landInformation?.isOwnLand = false;
                                }
                              });
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
                            "ඉඩම්හිමිගේ ඡායාරූපය",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 50),
                        child: selectLargeImage(
                          pickDeedImage,
                          size,
                          widget.media.photoOfDEED,
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
                  'Land information',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ],
      ),
    );
  }
}
