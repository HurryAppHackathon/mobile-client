import 'dart:io';
import 'dart:typed_data';

import 'package:day2/Apis/uploadeVideo.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class upLoadVideo extends StatefulWidget {
  const upLoadVideo({super.key});

  @override
  State<upLoadVideo> createState() => _upLoadVideoState();
}

class _upLoadVideoState extends State<upLoadVideo> {
  TextEditingController nameOFVideo = TextEditingController();
  TextEditingController dis = TextEditingController();
  File? galleryFile;
  final picker = ImagePicker();
  var fimg = null;
  @override
  Future getVideo(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    XFile? xfilePick = pickedFile;

    final uint8list = await VideoThumbnail.thumbnailData(
      video: xfilePick!.path,

      imageFormat: ImageFormat.JPEG,

      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 75,
    );

    setState(
      () {
        fimg = uint8list;
        galleryFile = File(pickedFile!.path);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: c3,
        appBar: AppBar(
          title: MyText(
              text: "Uploading a video", color: Colors.white, textSize: 20),
          centerTitle: true,
          leading: BackButton(
            color: Colors.white,
          ),
          backgroundColor: c2,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: galleryFile == null
                      ? Center(
                          child: MyText(
                              text: "Nothing selected",
                              color: Colors.white,
                              textSize: 20))
                      : fimg == null
                          ? Center(
                              child: MyText(
                                  text: "Loding..",
                                  color: Colors.white,
                                  textSize: 20))
                          : Container(
                              height: 150,
                              width: 150,
                              child: Image.memory(
                                fimg,
                                fit: BoxFit.contain,
                              ))),
              ElevatedButton(
                style:
                    ButtonStyle(backgroundColor: MaterialStateProperty.all(c5)),
                child: MyText(
                    text: "Select video from gallery or camera",
                    color: Colors.white,
                    textSize: 22),
                onPressed: () {
                  _showPicker(context: context);
                },
              ),
              Expanded(child: Container()),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 260,
                child: TextField(
                    controller: nameOFVideo,
                    decoration: InputDecoration(
                      fillColor: c2,
                      filled: true,
                      counter: Container(),
                      label: MyText(
                          text: "Name of the video",
                          color: Colors.white,
                          textSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: nameOFVideo.text.length < 3 &&
                                      nameOFVideo.text.isNotEmpty
                                  ? Colors.red
                                  : c2,
                              width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: nameOFVideo.text.length < 3 &&
                                    nameOFVideo.text.isNotEmpty
                                ? Colors.red
                                : c2,
                            width: 2.0),
                      ),
                    ),
                    maxLines: 1,
                    maxLength: 25,
                    onChanged: (value) => setState(() {
                          nameOFVideo.text = value;
                        }),
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 260,
                child: TextField(
                    controller: dis,
                    decoration: InputDecoration(
                      fillColor: c2,
                      filled: true,
                      counter: Container(),
                      label: MyText(
                          text: "Description of the video",
                          color: Colors.white,
                          textSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: dis.text.length < 3 && dis.text.isNotEmpty
                                  ? Colors.red
                                  : c2,
                              width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: dis.text.length < 3 && dis.text.isNotEmpty
                                ? Colors.red
                                : c2,
                            width: 2.0),
                      ),
                    ),
                    maxLines: 4,
                    maxLength: 250,
                    onChanged: (value) => setState(() {
                          dis.text = value;
                        }),
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
              ElevatedButton(
                style:
                    ButtonStyle(backgroundColor: MaterialStateProperty.all(c5)),
                child:
                    MyText(text: "Upload", color: Colors.white, textSize: 22),
                onPressed: () async {
                  if (galleryFile != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          backgroundColor: c2,
                          children: <Widget>[
                            Center(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Row(children: <Widget>[
                                CircularProgressIndicator(
                                  color: c5,
                                ),
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                ),
                                Text(
                                  "Uploading Please Wait!",
                                  style: TextStyle(color: c5),
                                ),
                              ]),
                            ))
                          ],
                        );
                      },
                    );

                    Uint8List imageInUnit8List =
                        fimg; // store unit8List image here ;
                    final tempDir = await getTemporaryDirectory();
                    File file =
                        await File('${tempDir.path}/image.png').create();
                    file.writeAsBytesSync(imageInUnit8List);

                    if (await UploadVideoToserver(
                        nameOFVideo.text, dis.text, galleryFile!, file)) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ],
          ),
        ));
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    getVideo(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getVideo(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
