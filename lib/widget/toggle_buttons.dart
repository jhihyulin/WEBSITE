import 'package:flutter/material.dart';

class CustomToggleButtons extends StatefulWidget {
  const CustomToggleButtons({
    Key? key,
    required this.children,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  final List<Widget> children;
  final List<bool> isSelected;
  final Function(int)? onPressed;

  @override
  State<CustomToggleButtons> createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(16),
      onPressed: widget.onPressed,
      isSelected: widget.isSelected,
      children: widget.children,
    );
  }
}
