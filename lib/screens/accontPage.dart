import 'dart:convert';
import 'dart:io';
import 'package:day2/Apis/getUser.dart';
import 'package:day2/Apis/setImageProf.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AccontPage extends StatefulWidget {
  const AccontPage({super.key});

  @override
  State<AccontPage> createState() => _AccontPageState();
}

class _AccontPageState extends State<AccontPage> {
  var userData;
  File? galleryFile;
  final picker = ImagePicker();
  var fimg = null;
  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(
      source: img,
      preferredCameraDevice: CameraDevice.front,
    );

    setState(
      () {
        galleryFile = File(pickedFile!.path);
      },
    );
    if (await setImage()) {
      getdata();
    }
  }

  Future getdata() async {
    userData = await jsonDecode(await getUserData());
    userData = userData["data"];
    setState(() {
      userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      getdata();
    }

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: c5,
                child: userData != null
                    ? CircleAvatar(
                      radius: 48,
                        backgroundImage:
                            NetworkImage(userData["user"]["avatar_url"]))
                    : Icon(
                        Icons.account_circle,
                        color: c2,
                        size: 90,
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              IconButton(
                  onPressed: () {
                    _showPicker(context: context);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 30,
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          userData == null
              ? Container()
              : MyText(
                  text: userData["user"]["username"],
                  color: Colors.white,
                  textSize: 20),
          userData == null
              ? Container()
              : MyText(
                  text: userData["user"]["email"],
                  color: Colors.white,
                  textSize: 20),
        ],
      ),
    );
  }

  Future setImage() async {
    if (galleryFile != null) {
      UploadImageToserver(galleryFile!);
    }
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
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
