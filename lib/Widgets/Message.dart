import 'package:flutter/material.dart';
import 'package:recommendation/Utils/MainColors.dart';
import 'package:recommendation/Utils/TextStyle.dart';

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  const Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}

class Messages extends StatefulWidget {
  final bool isUser;
  final String message;
  final DateTime date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: widget.isUser ? Colors.deepPurple : Colors.grey.shade200,
            gradient: LinearGradient(
              colors:
                  widget.isUser
                      ? [
                        MainColors.secondColor,
                        MainColors.secondColor.withRed(10),
                        MainColors.secondColor.withRed(100),
                      ]
                      : [Colors.grey.shade300, Colors.grey.shade200],
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30),
              bottomLeft:
                  widget.isUser ? const Radius.circular(25) : Radius.zero,
              topRight: const Radius.circular(30),
              bottomRight:
                  widget.isUser ? Radius.zero : const Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // يجعل الحاوية تأخذ فقط حجم المحتوى
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.message,
                style: Text_Style.textStyleNormal(
                  widget.isUser ? Colors.white : Colors.black,
                  16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
