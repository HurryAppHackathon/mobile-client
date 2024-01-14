//import 'package:day2/Apis/sokets.dart';
import 'dart:convert';
import 'dart:ffi';

import 'package:day2/Apis/authstuf.dart';
import 'package:day2/Apis/getListOfVideos.dart';
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
  late FlickManager flickManager;
  List<IO.Socket> sockets = [];
  String vdeoUrl = "";
  final ValueNotifier<String> newMsg = ValueNotifier<String>("");

  VideoPlayerController v = VideoPlayerController.networkUrl(Uri.parse(""));
  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse("")));
    connectToSocket(widget.partydata["id"]);
  }

  List msgs = [];
  @override
  void dispose() {
    for (IO.Socket socket in sockets) {
      socket.disconnect();
      socket.close();
     
    }
    sockets.clear();
    flickManager.dispose();
    super.dispose();
  }

  TextEditingController comment = TextEditingController();
  double sliderValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c3,
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setVideo(widget.partydata["id"]);
                },
                icon: Icon(
                  Icons.video_collection_sharp,
                  color: c5,
                  size: 30,
                ))
          ],
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
                color: Colors.amber,
                child: FlickVideoPlayer(
                  flickManager: flickManager,
                  flickVideoWithControls: FlickVideoWithControls(
                    controls:
                        FlickSeekVideoAction(duration: Duration(seconds: 2)),
                    videoFit: BoxFit.fill,
                  ),
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
                      sendMsg(comment.text);
                      setState(() {
                        comment.text = "";
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

  Future<void> connectToSocket(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("TOKEN") ?? "";

    IO.Socket socket = IO.io(
      'http://104.248.128.150:3000',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'authorization': token})
          .build(),
    );
  
    
    
    socket.onConnect((_) {
      sockets.add(socket);
      socket.emit('join-party', {"partyId": id});
    });

    socket.onConnectError((data) {
      print("Connection Error: $data");
    });

    socket.onConnectTimeout((data) {
      print("Connection Timeout: $data");
    });

    

    socket.on('user', (data) => print("User: $data"));
    socket.on("exception", (data) => print("Exception: $data"));
    socket.on("video-pause-receive", (data) {
      flickManager.flickControlManager?.pause();
    });
    socket.on("video-resume-receive", (data) {
      flickManager.flickControlManager?.play();
    });
    socket.on("video-seek-receive", (data) {
      double millis = double.parse(data["time"].toString());

      flickManager.flickControlManager
          ?.seekTo(Duration(milliseconds: (millis * 1000).toInt()));
    });

    socket.on("party-joined", (data) {
      final l = data["videoUrl"];
      flickManager
          .handleChangeVideo(VideoPlayerController.networkUrl(Uri.parse(l)));
      print(data["messages"]);
      setState(() {
        for (var i = 0; i < data["messages"].length; i++) {
          msgs.add(data["messages"][i]["message"]);
        }
      });
    });

    socket.on(
      "message-receive",
      (data) {
        print("Message Received: $data");
        {
          setState(() {
            msgs.add(
                {"text": data["message"], "url": data["user"]["avatar_url"]});
          });
        }
        // Handle message data and update state accordingly
      },
    );

    socket.on("video-set-receive", ((data) {
      print(data["videoUrl"]);
      final l = data["videoUrl"];
      flickManager
          .handleChangeVideo(VideoPlayerController.networkUrl(Uri.parse(l)));
      print("HEREEEE");
      // flickManager.handleChangeVideo( VideoPlayerController.networkUrl(data["videoUrl"]));

      // Handle video set data and update state accordingly
    }));
  }

  Future sendMsg(msg) async {
    final socket = sockets[0];
    print(sockets);
    socket.connect;
    print("MSG>>>>>>>>>>>>>>>>>>>>>>>>>..");

    socket.emit(
        'message-send', {"partyId": widget.partydata["id"], "message": msg});
  }

  Future<void> sendVideoSeek(Duration duration) async {
    final socket = sockets[0];
    print(sockets);
    socket.connect;
    print("Seeking to: $duration");

    socket.emit('video-manage-send', {
      "partyId": widget.partydata["id"],
      "action": 'seek',
      "time": duration.inMilliseconds,
    });
  }

  void setVideo(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
              child: Text("Set video",
                  style: TextStyle(color: Colors.white, fontSize: 20))),
          backgroundColor: c2,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          content: Container(
            height: 300,
            child: Expanded(
              child: FutureBuilder(
                future: getListOFVideos(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                  }
                  final data = jsonDecode(snapshot.data)["data"];
                  print(data);
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(color: c1, child: ListTile());
                    },
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text("Set",
                    style: TextStyle(color: Colors.white, fontSize: 16))),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("quit",
                    style: TextStyle(color: Colors.white, fontSize: 16)))
          ],
        );
      },
    );
  }
}
