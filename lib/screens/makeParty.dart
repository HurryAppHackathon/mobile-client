import 'package:day2/Apis/makeParty.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';

class makeParty extends StatefulWidget {
  const makeParty({super.key});

  @override
  State<makeParty> createState() => _makePartyState();
}

class _makePartyState extends State<makeParty> {
  TextEditingController nameOfParty = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      appBar: AppBar(
        title: MyText(
            text: "Uploading a video", color: Colors.white, textSize: 20),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: c2,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: 260,
              child: TextField(
                  controller: nameOfParty,
                  decoration: InputDecoration(
                    fillColor: c2,
                    filled: true,
                    counter: Container(),
                    label: MyText(
                        text: "Name of the Party",
                        color: Colors.white,
                        textSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: nameOfParty.text.length < 3 &&
                                    nameOfParty.text.isNotEmpty
                                ? Colors.red
                                : c2,
                            width: 2.0)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: nameOfParty.text.length < 3 &&
                                  nameOfParty.text.isNotEmpty
                              ? Colors.red
                              : c2,
                          width: 2.0),
                    ),
                  ),
                  maxLines: 1,
                  maxLength: 30,
                  onChanged: (value) => setState(() {
                        nameOfParty.text = value;
                      }),
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
              style:
                  ButtonStyle(backgroundColor: MaterialStateProperty.all(c5)),
              child:
                  MyText(text: "Make party", color: Colors.white, textSize: 22),
              onPressed: () async {
                if (nameOfParty.text.isNotEmpty) {
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
                                "Please Wait!",
                                style: TextStyle(color: c5),
                              ),
                            ]),
                          ))
                        ],
                      );
                    },
                  );
                  if (await MakeParty(nameOfParty.text)) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
