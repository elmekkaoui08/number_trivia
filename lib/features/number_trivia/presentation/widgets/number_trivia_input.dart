import 'package:flutter/material.dart';

class NumberTriviaInput extends StatelessWidget {
  NumberTriviaInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.all(8),
      // padding: EdgeInsets.only(left: 8, bottom: 8),
      height: size.height * .07,
      width: size.width * .8,
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: TextField(
          controller: controller,
          cursorHeight: size.height * .05,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              border: InputBorder.none,
              // hintText: 'Search',
              hintStyle: TextStyle()),
        ),
      ),
    );
  }
}
