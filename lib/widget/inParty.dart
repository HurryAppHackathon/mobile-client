//import 'package:day2/Apis/sokets.dart';
import 'package:day2/const/MyColors.dart';
import 'package:day2/const/utlis.dart';
import 'package:day2/widget/msgWidget.dart';
import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class party extends StatefulWidget {
  const party({super.key, required this.partydata, this.vu});
  final partydata;
  final vu;
  @override
  State<party> createState() => _partyState();
}

class _partyState extends State<party> {
  String vdeoUrl =
      "http://172.20.10.6:9000/streamingapi/videos/1/in2UPgdta9kgPuIHeYoieXQBWwkax5GoAzn6wIBl.mp4";
  String newMsg = "";
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    connectToSocket(widget.partydata["id"]);
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(vdeoUrl)),
    );
  }

  List msgs = [];
  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  TextEditingController comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      appBar: AppBar(
          backgroundColor: c2,
          title: MyText(
              text: widget.partydata["name"],
              color: Colors.white,
              textSize: 20),
          centerTitle: true,
          leading: const BackButton(
            color: Colors.white,
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 250,
                child: FlickVideoPlayer(
                  flickManager: flickManager,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: Utils(context).screenSize.width * 0.78,
                    child: MyText(
                      text: "nothin rhit now",
                      color: Colors.grey,
                      textSize: 14,
                      maxLines: 5,
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: c5, width: 2)),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: MyText(
                              text: "200",
                              color: Colors.white,
                              textSize: 17,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Icon(
                            Icons.people_rounded,
                            color: Colors.white,
                          )
                        ],
                      ))
                ],
              ),
              const Divider(
                thickness: 2,
                color: c2,
              ),
            ],
          ),
          Expanded(
              child: Container(
                  child: ListView.builder(
            itemCount: msgs.length,
            itemBuilder: (context, index) {
              return msgWidget(
                  text: msgs[index]["text"], url: msgs[index]["url"]);
            },
          ))),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 5,
              left: 15,
              right: 15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 260,
                  child: TextField(
                      controller: comment,
                      decoration: InputDecoration(
                        fillColor: c2,
                        filled: true,
                        counter: Container(),
                        label: MyText(
                            text: "Message", color: Colors.white, textSize: 16),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: comment.text.length < 3 &&
                                        comment.text.isNotEmpty
                                    ? Colors.red
                                    : c2,
                                width: 2.0)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: comment.text.length < 3 &&
                                      comment.text.isNotEmpty
                                  ? Colors.red
                                  : c2,
                              width: 2.0),
                        ),
                      ),
                      maxLines: 1,
                      maxLength: 25,
                      onChanged: (value) => setState(() {
                            comment.text = value;
                          }),
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        newMsg = comment.text;
                      });
                    },
                    child: Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                            color: c2, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.send,
                          color: c5,
                          size: 40,
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future connectToSocket(int id) async {
    // Dart client
    final prefs = await SharedPreferences.getInstance();

    final token = await prefs.getString("TOKEN") ?? "";
    print(
        "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    IO.Socket socket = IO.io(
        'http://172.20.10.6:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'authorization': token}) // optional
            .build());
    socket.connect();
    print(
        "p<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    socket.onConnect((_) {
      print("DDDDDDDDDDDDDDDDD CCCCCCCCCCCCCCCCCCCCC    TTTTTTTTTTTTTTTTTTTTT");
      socket.emit('join-party', {"partyId": "1"});
      socket.emit('video-manage-send',
          {"partyId": "1", "action": 'set_video', "videoId": "1"});
      socket.emit('video-manage-send',
          {"partyId": "1", "action": 'set_video', "videoId": "1"});
      if (newMsg.isNotEmpty) {
        socket.emit('message-send', {"partyId": "1", "message": newMsg});
        print(newMsg);
        setState(() {
          newMsg = "";
        });
      }
    });

    //socket.on('user', (data) => print(data));
    //socket.on("exception", (data) => print(data));
    socket.on("party-joined", (data) => print(data));
    socket.on(
      "message-receive",
      (data) {
        setState(() {
          msgs.add(
              {"text": data["message"], "url": data["user"]["avatar_url"]});
        });
      },
    );
    socket.on("video-set-receive", ((data) {
      print(
          "ITS HERE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(data);
      if (vdeoUrl != data[vdeoUrl]) {
        vdeoUrl = data["videoUrl"];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                party(partydata: widget.partydata, vu: vdeoUrl),
          ),
        );
      }
    }));
  }
}
