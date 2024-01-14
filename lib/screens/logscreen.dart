import 'dart:convert';

import 'package:day2/Apis/authstuf.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool onlogin = true;
  TextEditingController fName = TextEditingController();
  TextEditingController sName = TextEditingController();
  TextEditingController usarName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c1,
      appBar: AppBar(
        backgroundColor: c2,
        title: MyText(text: "TDV", color: Colors.white, textSize: 20),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          //  color: Colors.amber,
          margin: EdgeInsets.all(20),
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: onlogin ? "Login with your info" : "Register your info",
                color: Colors.white,
                textSize: 25,
                isTitle: true,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  //color: c5,
                  child: Image.asset("assets/imgs/Group.png"),
                ),
              ),
              onlogin
                  ? Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                                controller: usarName,
                                decoration: InputDecoration(
                                  fillColor: c2,
                                  filled: true,
                                  counter: Container(),
                                  label: MyText(
                                      text: "Username",
                                      color: Colors.white,
                                      textSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: usarName.text.length < 3 &&
                                                  usarName.text.isNotEmpty
                                              ? Colors.red
                                              : c2,
                                          width: 2.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: usarName.text.length < 3 &&
                                                usarName.text.isNotEmpty
                                            ? Colors.red
                                            : c2,
                                        width: 2.0),
                                  ),
                                ),
                                maxLines: 1,
                                maxLength: 25,
                                onChanged: (value) => setState(() {
                                      usarName.text = value;
                                    }),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  fillColor: c2,
                                  filled: true,
                                  counter: Container(),
                                  label: MyText(
                                      text: "Password",
                                      color: Colors.white,
                                      textSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: password.text.length < 3 &&
                                                  password.text.isNotEmpty
                                              ? Colors.red
                                              : c2,
                                          width: 2.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: password.text.length < 3 &&
                                                password.text.isNotEmpty
                                            ? Colors.red
                                            : c2,
                                        width: 2.0),
                                  ),
                                ),
                                maxLines: 1,
                                maxLength: 25,
                                onChanged: (value) => setState(() {
                                      password.text = value;
                                    }),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 320,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                    controller: fName,
                                    decoration: InputDecoration(
                                      fillColor: c2,
                                      filled: true,
                                      counter: Container(),
                                      label: MyText(
                                          text: "First name",
                                          color: Colors.white,
                                          textSize: 16),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: fName.text.length < 3 &&
                                                      fName.text.isNotEmpty
                                                  ? Colors.red
                                                  : c2,
                                              width: 2.0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: fName.text.length < 3 &&
                                                    fName.text.isNotEmpty
                                                ? Colors.red
                                                : c2,
                                            width: 2.0),
                                      ),
                                    ),
                                    maxLines: 1,
                                    maxLength: 25,
                                    onChanged: (value) => setState(() {
                                          fName.text = value;
                                        }),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                              Container(
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                    controller: sName,
                                    decoration: InputDecoration(
                                      fillColor: c2,
                                      filled: true,
                                      counter: Container(),
                                      label: MyText(
                                          text: "last name",
                                          color: Colors.white,
                                          textSize: 16),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: sName.text.length < 3 &&
                                                      sName.text.isNotEmpty
                                                  ? Colors.red
                                                  : c2,
                                              width: 2.0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: sName.text.length < 3 &&
                                                    sName.text.isNotEmpty
                                                ? Colors.red
                                                : c2,
                                            width: 2.0),
                                      ),
                                    ),
                                    maxLines: 1,
                                    maxLength: 25,
                                    onChanged: (value) => setState(() {
                                          sName.text = value;
                                        }),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                                controller: usarName,
                                decoration: InputDecoration(
                                  fillColor: c2,
                                  filled: true,
                                  counter: Container(),
                                  label: MyText(
                                      text: "Username",
                                      color: Colors.white,
                                      textSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: usarName.text.length < 3 &&
                                                  usarName.text.isNotEmpty
                                              ? Colors.red
                                              : c2,
                                          width: 2.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: usarName.text.length < 3 &&
                                                usarName.text.isNotEmpty
                                            ? Colors.red
                                            : c2,
                                        width: 2.0),
                                  ),
                                ),
                                maxLines: 1,
                                maxLength: 25,
                                onChanged: (value) => setState(() {
                                      usarName.text = value;
                                    }),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                  fillColor: c2,
                                  filled: true,
                                  counter: Container(),
                                  label: MyText(
                                      text: "E-mail",
                                      color: Colors.white,
                                      textSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: usarName.text.length < 3 &&
                                                  usarName.text.isNotEmpty
                                              ? Colors.red
                                              : c2,
                                          width: 2.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: usarName.text.length < 3 &&
                                                email.text.isNotEmpty
                                            ? Colors.red
                                            : c2,
                                        width: 2.0),
                                  ),
                                ),
                                maxLines: 1,
                                maxLength: 25,
                                onChanged: (value) => setState(() {
                                      email.text = value;
                                    }),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  fillColor: c2,
                                  filled: true,
                                  counter: Container(),
                                  label: MyText(
                                      text: "Password",
                                      color: Colors.white,
                                      textSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: password.text.length < 3 &&
                                                  password.text.isNotEmpty
                                              ? Colors.red
                                              : c2,
                                          width: 2.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: password.text.length < 3 &&
                                                password.text.isNotEmpty
                                            ? Colors.red
                                            : c2,
                                        width: 2.0),
                                  ),
                                ),
                                maxLines: 1,
                                maxLength: 25,
                                onChanged: (value) => setState(() {
                                      password.text = value;
                                    }),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            onlogin = true;
                          });
                        },
                        child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                color: onlogin ? c5 : c1,
                                border: const Border(
                                    bottom: BorderSide(color: c5, width: 4),
                                    left: BorderSide(color: c5, width: 4),
                                    top: BorderSide(color: c5, width: 4),
                                    right: BorderSide(color: c5, width: 4)),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            alignment: Alignment.center,
                            child: MyText(
                              text: "Login",
                              color: Colors.white,
                              textSize: 20,
                              isTitle: true,
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            onlogin = false;
                          });
                        },
                        child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                color: onlogin ? c1 : c5,
                                border: const Border(
                                    bottom: BorderSide(color: c5, width: 4),
                                    left: BorderSide(color: c5, width: 4),
                                    top: BorderSide(color: c5, width: 4),
                                    right: BorderSide(color: c5, width: 4)),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            alignment: Alignment.center,
                            child: MyText(
                              text: "Register",
                              color: Colors.white,
                              textSize: 20,
                              isTitle: true,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      submit();
                    },
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: c5),
                      alignment: Alignment.center,
                      child: MyText(
                          text: "Submit", color: Colors.white, textSize: 20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future submit() async {
    if (onlogin) {
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
                    "Checking in Please Wait!",
                    style: TextStyle(color: c5),
                  ),
                ]),
              ))
            ],
          );
        },
      );
      final r = await login(usarName.text, password.text);
      if (r == true) {
        Navigator.popAndPushNamed(context, "/");
      } else {
        Navigator.of(context).pop();

        final msg = jsonDecode(r)["message"] ?? "";
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                backgroundColor: c2,
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        msg,
                        style: TextStyle(color: c5),
                      ),
                    ),
                  )
                ],
              );
            });
      }
    } else {
      if (!onlogin) {
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
                      "Checking in Please Wait!",
                      style: TextStyle(color: c5),
                    ),
                  ]),
                ))
              ],
            );
          },
        );
        final r = await register(
            usarName.text, password.text, email.text, fName.text, sName.text);
        if (r == true) {
          Navigator.popAndPushNamed(context, "/");
        } else {
          Navigator.of(context).pop();
          print("????????????????????????????????????????");
          print(r);
          final msg = jsonDecode(r)["message"] ?? "";
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  backgroundColor: c2,
                  children: <Widget>[
                    Center(
                        child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        msg,
                        style: TextStyle(color: c5),
                      ),
                    ))
                  ],
                );
              });
        }
      }
    }
  }
}
