import 'dart:io';

import '../../models/estimation.dart';
import '../../models/land_info.dart';
import '../../models/location.dart';
import '../../models/media.dart';
import '../../models/media_url.dart';
import '../../models/personal_info.dart';
import '../../screens/submit/submit_page.dart';
import '../../service/location_service.dart';
import '../../service/validation.dart';
import '../../widgets/select_media.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../form_handler.dart';

class PhotoUpload extends StatefulWidget {
  final Media? media;
  final ImagePicked? imagePicked;
  final Function increasePageNumber;
  final GlobalKey<FormState> formKey;
  final Estimation estimation;
  final PersonalInfo personalInfo;
  final LocationModel location;
  final LandInfo landInfo;
  final MediaUrl mediaUrl;
  PhotoUpload({
    Key? key,
    this.media,
    this.imagePicked,
    required this.increasePageNumber,
    required this.estimation,
    required this.personalInfo,
    required this.formKey,
    required this.location,
    required this.landInfo,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  ImagePicker _imagePicker = ImagePicker();
  LocationService locationService = LocationService();
  Validation validation = Validation();
  LocationData? position;
  String? imageUrl;
  bool? isFormValidate = false;
  bool? isMediaValidate = false;

  Future<void> imgFromCamera(String imageNum) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);

    File? file;
    if (image != null) {
      file = File(image.path);
    }

    switch (imageNum) {
      case "image1":
        setState(() {
          widget.media?.image1 = file;
          widget.imagePicked?.isImagePicked = true;
        });
        break;
      case "image2":
        setState(() {
          widget.media?.image2 = file;
          widget.imagePicked?.isImagePicked = true;
        });
        break;
      case "image3":
        setState(() {
          widget.media?.image3 = file;
          widget.imagePicked?.isImagePicked = true;
        });
        break;
      case "image4":
        setState(() {
          widget.media?.image4 = file;
          widget.imagePicked?.isImagePicked = true;
        });
        break;
      case "image5":
        setState(() {
          widget.media?.image5 = file;
          widget.imagePicked?.isImagePicked = true;
        });
        break;
      case "image6":
        setState(() {
          widget.media?.image6 = file;
          widget.imagePicked?.isImagePicked = true;
        });
        break;
      default:
    }
  }

  void removeImage(String imageNum) {
    switch (imageNum) {
      case "image1":
        setState(() {
          widget.media?.image1 = null;
        });
        break;
      case "image2":
        setState(() {
          widget.media?.image2 = null;
        });
        break;
      case "image3":
        setState(() {
          widget.media?.image3 = null;
        });
        break;
      case "image4":
        setState(() {
          widget.media?.image4 = null;
        });
        break;
      case "image5":
        setState(() {
          widget.media?.image5 = null;
        });
        break;
      case "image6":
        setState(() {
          widget.media?.image6 = null;
        });
        break;
      default:
    }
  }

  void videoPicker() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(5),
        contentPadding: EdgeInsets.all(20),
        content: Container(
          height: 150,
          child: Column(
            children: [
              Text(
                "Choose video source",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              Container(
                width: 150,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera),
                      SizedBox(width: 20),
                      Text("Camera"),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
              ),
              Container(
                width: 150,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_collection_outlined),
                      SizedBox(width: 20),
                      Text("Gallery"),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((ImageSource? source) async {
      if (source != null) {
        final XFile? video = await _imagePicker.pickVideo(source: source);
        File? file;
        if (video != null) {
          file = File(video.path);
        }

        setState(() {
          widget.media?.video = file;
        });
      }
    });
  }

  void removeVideo() {
    setState(() {
      widget.media?.video = null;
    });
  }

  @override
  void initState() {
    widget.increasePageNumber(3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              selectImage(
                  imgFromCamera, widget.media?.image1, "image1", removeImage),
              selectImage(
                  imgFromCamera, widget.media?.image2, "image2", removeImage),
              selectImage(
                  imgFromCamera, widget.media?.image3, "image3", removeImage),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              selectImage(
                  imgFromCamera, widget.media?.image4, "image4", removeImage),
              selectImage(
                  imgFromCamera, widget.media?.image5, "image5", removeImage),
              selectImage(
                  imgFromCamera, widget.media?.image6, "image6", removeImage),
            ],
          ),
          SizedBox(height: 20),
          selectVideo(videoPicker, size, widget.media?.video, removeVideo),
          SizedBox(height: 20),
          Container(
            width: size.width * 0.5,
            child: ElevatedButton(
              onPressed: () async {
                position = await locationService.getLocation(context);
                if (position != null) {
                  widget.location.latitude = position?.latitude;
                  widget.location.longitude = position?.longitude;
                }
                if (widget.media?.image1 == null) {
                  imgFromCamera("image1");
                } else if (widget.media?.image2 == null) {
                  imgFromCamera("image2");
                } else if (widget.media?.image3 == null) {
                  imgFromCamera("image3");
                } else if (widget.media?.image4 == null) {
                  imgFromCamera("image4");
                } else if (widget.media?.image5 == null) {
                  imgFromCamera("image5");
                } else if (widget.media?.image6 == null) {
                  imgFromCamera("image6");
                }
              },
              child: widget.imagePicked!.isImagePicked!
                  ? Text("Take Picture again")
                  : Text("Take a Picture"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black54)),
            ),
          ),
          Container(
            width: size.width * 0.5,
            child: ElevatedButton(
              onPressed: () async {
                isFormValidate = validation.validateForm(widget.personalInfo,
                    widget.landInfo, widget.estimation, context);

                if (isFormValidate == true)
                  isMediaValidate =
                      validation.validateMedia(widget.media!, context);
                if ((isFormValidate == true) && (isMediaValidate == true))
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubmitPage(
                        estimation: widget.estimation,
                        personalInfo: widget.personalInfo,
                        landInfo: widget.landInfo,
                        media: widget.media!,
                        mediaUrl: widget.mediaUrl,
                        location: widget.location,
                      ),
                    ),
                  );
              },
              child: Text("Next"),
            ),
          ),
        ],
      ),
    );
  }
}
