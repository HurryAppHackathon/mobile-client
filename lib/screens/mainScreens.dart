import 'package:day2/Apis/authstuf.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/screens/logscreen.dart';
import 'package:day2/screens/makeParty.dart';
import 'package:day2/screens/uploadVideoScreen.dart';
import 'package:day2/widget/exploar.dart';
import 'package:day2/widget/myVideos.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  var usarData;
  List pages = [
    const MyVideos(),
    const explore(),
    const MyVideos(),
  ];
  bool checkIFloged = false;
  Future log() async {
    final r = await loginwithToken();
    setState(() {
      if (r != false) {
        usarData = r;
      }
      checkIFloged = true;
    });
   
  }

  @override
  Widget build(BuildContext context) {
    if (!checkIFloged) {
      log();
    }

    return checkIFloged == false
        ? Scaffold(
            backgroundColor: c3,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : checkIFloged&&usarData == null
            ? loginScreen()
            : Scaffold(
                backgroundColor: c3,
                appBar: AppBar(
                    backgroundColor: c2,
                    title:
                        MyText(text: "TDV", color: Colors.white, textSize: 20),
                    centerTitle: true),
                body: pages[_selectedIndex],
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: c2,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore),
                      label: 'explore',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      label: 'Account',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: c5,
                  unselectedItemColor: c6,
                  onTap: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
                floatingActionButton: _selectedIndex < 2
                    ? InkWell(
                        onTap: () {
                          if (_selectedIndex == 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const upLoadVideo(),
                                ));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const makeParty(),
                                ));
                          }
                        },
                        child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: c5,
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            )),
                      )
                    : Container(),
              );
  }
}
