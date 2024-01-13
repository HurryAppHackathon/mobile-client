import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

Future connectToSockets(int id) async {
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
      "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
  socket.onConnect((_) {
    print("DDDDDDDDDDDDDDDDD CCCCCCCCCCCCCCCCCCCCC    TTTTTTTTTTTTTTTTTTTTT");
    socket.emit('join-party', {"partyId": "1"});
            socket.emit('video-manage-send', { "partyId": "1", "action": 'set_video', "videoId": "1" });

  });
  
  socket.on('user', (data) => print(data));
  socket.on("exception", (data) => print(data));
  socket.on("party-joined", (data) => print(data));
  socket.on("message-receive", (data) => print(data));
  socket.on("video-set-receive", (data) => print(data["videoUrl"]));
}
