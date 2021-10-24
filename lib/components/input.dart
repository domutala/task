import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String? hintText;
  final TextStyle? textStyle;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final bool autofocus;

  const Input({
    Key? key,
    required this.controller,
    this.hintText,
    this.textStyle,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 0),
      borderRadius: BorderRadius.zero,
    );

    var style = widget.textStyle ??
        TextStyle(
          fontSize: 18,
          color: Theme.of(context).primaryColorDark,
        );

    return TextField(
      autofocus: widget.autofocus,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColorDark.withOpacity(.3),
        ),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: border,
        border: border,
        focusedBorder: border,
      ),
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      style: style,
      onChanged: (v) {},
    );
  }
}
