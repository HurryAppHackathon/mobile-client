import 'package:day2/widget/textWidget.dart';
import 'package:flutter/material.dart';

class msgWidget extends StatelessWidget {
  const msgWidget({super.key, required this.text, required this.url});
  final text, url;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(url),
        
      ),
      title: MyText(text: text, color: Colors.white, textSize: 16),
    );
  }
}
