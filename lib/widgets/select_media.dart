import 'dart:io';
import 'package:flutter/material.dart';

Widget selectImage(Function imgFromCamera, File? image, String imageNum,
    Function removeImage) {
  return image == null
      ? Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black12,
          ),
          height: 80,
          width: 100,
          child: Center(
            child: Icon(Icons.add_a_photo_rounded),
          ),
        )
      : Stack(
          children: [
            Container(
              height: 80,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  child: Icon(Icons.cancel, color: Colors.white),
                  onTap: () {
                    removeImage(imageNum);
                  },
                )),
          ],
        );
}

Widget selectVideo(
    Function pickVideo, Size size, File? video, Function removeVideo) {
  return video == null
      ? GestureDetector(
          onTap: () {
            pickVideo();
          },
          child: Container(
            height: 130,
            width: size.width * 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_call_outlined,
                    size: 40,
                  ),
                  Text("Tap to record a video"),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black12,
            ),
          ),
        )
      : Stack(
          children: [
            Container(
              height: 130,
              width: size.width * 0.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 40,
                    ),
                    Text("Video recorded"),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green[100],
              ),
            ),
            Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  child: Icon(Icons.cancel),
                  onTap: () {
                    removeVideo();
                  },
                )),
          ],
        );
}

Widget selectLargeImage(
    Function pickImage, Size size, File? image, Function removeImage) {
  return image == null
      ? GestureDetector(
          onTap: () {
            pickImage();
          },
          child: Container(
            height: 120,
            width: size.width * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 30,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black12,
            ),
          ),
        )
      : Stack(
          children: [
            Container(
              height: 120,
              width: size.width * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  child: Icon(Icons.cancel, color: Colors.white),
                  onTap: () {
                    removeImage();
                  },
                )),
          ],
        );
}
