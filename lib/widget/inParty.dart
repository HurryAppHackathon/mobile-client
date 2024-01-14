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
  late FlickManager flickManager;
  List<IO.Socket> sockets = [];
  String vdeoUrl = "";
  final ValueNotifier<String> newMsg = ValueNotifier<String>("");

  VideoPlayerController v = VideoPlayerController.networkUrl(Uri.parse(
      "http://104.248.128.150:9000/streamingapi/videos/1/BsLyMHYU9Xw6IJbZQhIzjwbKhDaoaEPwBnljb18t.mp4"));
  @override
  void initState() {
    super.initState();
    connectToSocket(widget.partydata["id"]);
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse("")));
  }

  List<Map<String, String>> msgs = [];
  @override
  void dispose() {
    print(sockets);
    for (IO.Socket socket in sockets) {
      print(sockets);
      socket.disconnect();
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
                    controls: FlickPortraitControls(),
                    videoFit: BoxFit.fill,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: Utils(context).screenSize.width * 0.78,
                    child: MyText(
                      text: "This is the description",
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
                              text:
                                  widget.partydata["memberCounter"].toString(),
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
                          ),
                          const SizedBox(
                            width: 5,
                          ),
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("TOKEN") ?? "";
      print(token);

      IO.Socket socket = IO.io(
        'http://104.248.128.150:3000',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'authorization': token})
            .build(),
      );
      print("______________________________");
      socket.onConnect((_) {
        sockets.clear();
        sockets.add(socket);

        socket.emit('join-party', {"partyId": id});
      });

      socket.onConnectError((data) {
        print("Connection Error: $data");
      });

      socket.onConnectTimeout((data) {
        print("Connection Timeout: $data");
      });

      socket.connect();

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
        print(data);

        if (l != null) {
          flickManager.handleChangeVideo(
              VideoPlayerController.networkUrl(Uri.parse(l??"http://104.248.128.150:9000/streamingapi/videos/1/BsLyMHYU9Xw6IJbZQhIzjwbKhDaoaEPwBnljb18t.mp4")));
        }
      });

      socket.on("video-set-receive", ((data) {
        print(data["videoUrl"]);
        final l = data["videoUrl"];
        flickManager
            .handleChangeVideo(VideoPlayerController.networkUrl(Uri.parse(l??"http://104.248.128.150:9000/streamingapi/videos/1/BsLyMHYU9Xw6IJbZQhIzjwbKhDaoaEPwBnljb18t.mp4")));
        print("HEREEEE");
        // flickManager.handleChangeVideo( VideoPlayerController.networkUrl(data["videoUrl"]));

        // Handle video set data and update state accordingly
      }));
      socket.on(
        "message-receive",
        (data) {
          print("Message Received: $data");
          {
            setmsg(
                {"text": data["message"], "url": data["user"]["avatar_url"]});
          }
          // Handle message data and update state accordingly
        },
      );
    } catch (e) {
      print("Error connecting to socket: $e");
      // Handle the error appropriately
    }
  }

  void setmsg(var m) {
    setState(() {
      msgs.add(m ??
          {
            "text": "Test",
            "url": "https://cdn-icons-png.flaticon.com/512/7626/7626666.png"
          });
    });
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
}
