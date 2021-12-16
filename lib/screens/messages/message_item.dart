import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final String? message;
  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Container(
          margin: EdgeInsets.all(10), child: Text(message.toString())),
    );
  }
}
