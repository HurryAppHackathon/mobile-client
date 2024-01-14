import 'dart:convert';
import 'package:day2/Apis/getUser.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';

class AccontPage extends StatefulWidget {
  const AccontPage({super.key});

  @override
  State<AccontPage> createState() => _AccontPageState();
}

class _AccontPageState extends State<AccontPage> {
  var userData;

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
                    ? Image.network(userData["user"]["avatar_url"])
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
                  onPressed: () {},
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
}
