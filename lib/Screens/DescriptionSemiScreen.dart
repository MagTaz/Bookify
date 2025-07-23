import 'package:flutter/material.dart';
import 'package:recommendation/Utils/MainColors.dart';
import 'package:recommendation/Utils/TextStyle.dart';

class DescriptionSemiScreen extends StatefulWidget {
  const DescriptionSemiScreen({super.key, required this.description});
  final String description;

  @override
  State<DescriptionSemiScreen> createState() => _DescriptionSemiScreenState();
}

class _DescriptionSemiScreenState extends State<DescriptionSemiScreen> {
  bool isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isExpanded ? 280 : 120,
            width: widthScreen,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics:
                  isExpanded
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
              child: Text(
                widget.description,
                style: Text_Style.textStyleNormal(
                  Colors.black.withOpacity(0.8),
                  16,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });

              if (!isExpanded) {
                _scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              isExpanded ? "Read Less" : "Read More",
              style: Text_Style.textStyleBold(MainColors.mainColor, 14),
            ),
          ),
        ],
      ),
    );
  }
}
