import 'dart:convert';

import 'package:day2/Apis/getListOfVideos.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';

class MyVideos extends StatefulWidget {
  const MyVideos({super.key});

  @override
  State<MyVideos> createState() => _MyVideosState();
}

class _MyVideosState extends State<MyVideos> {
  final videos = getListOFVideos();
  var data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FutureBuilder(
        future: videos,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            data = jsonDecode(snapshot.data);
            
          }
          return snapshot.hasData==false
              ? Container()
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemCount: data["data"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                          image: NetworkImage(
                            data["data"][index]["thumbnail_url"],
                          ),
                        ))),
                      ),
                      SizedBox(height: 5,),
                      Container(
                          child: MyText(
                        text: data["data"][index]["name"],
                        color: Colors.white,
                        textSize: 14,
                        maxLines: 2,
                      ))
                    ]);
                  },
                );
        },
      ),
    );
  }
}
