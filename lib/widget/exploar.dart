import 'dart:convert';

import 'package:day2/Apis/getPartyes.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/widget/inParty.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';

class explore extends StatefulWidget {
  const explore({super.key});

  @override
  State<explore> createState() => _exploreState();
}

class _exploreState extends State<explore> {
  Future patyes = getListOFpartys();
  var data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 20, right: 20),
      child: FutureBuilder(
          future: patyes,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              data = jsonDecode(snapshot.data);
              
            }
            return snapshot.hasData == false
                ? Container()
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20),
                    itemCount: data["data"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => party(partydata:data["data"][index] ),
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: c1,
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          child: Column(children: [
                            SizedBox(
                              height: 4,
                            ),
                            Expanded(
                              child: Container(
                                  decoration:  BoxDecoration(
                                      image: DecorationImage(
                                image: NetworkImage(
                                  data["data"][index]["image_url"],
                                ),
                              ))),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                                child: MyText(
                              text: data["data"][index]["name"],
                              color: Colors.white,
                              textSize: 20,
                              maxLines: 2,
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                         CircleAvatar(
                                          backgroundImage: NetworkImage(data["data"][index]["owner"]["avatar_url"]),
                                          backgroundColor: c3,
                                          radius: 20,
                                          
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                            child: MyText(
                                          text: data["data"][index]["owner"]["username"],
                                          color: Colors.white,
                                          textSize: 18,
                                          maxLines: 2,
                                        )),
                                      ],
                                    ),
                                    Container(
                                      width: 50,
                                        child: MyText(
                                      text: data["data"][index]["owner"]["created_at"],
                                      color: Colors.grey,
                                      textSize: 12,
                                      maxLines: 2,
                                    )),
                                  ],
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border:
                                            Border.all(color: c5, width: 2)),
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        MyText(
                                          text: "20",
                                          color: Colors.white,
                                          textSize: 20,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.people_rounded,
                                          color: Colors.white,
                                        )
                                      ],
                                    ))
                              ],
                            )
                          ]),
                        ),
                      );
                    },
                  );
          }),
    );
  }
}
