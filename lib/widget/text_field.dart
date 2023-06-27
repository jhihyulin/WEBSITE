import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction,
    this.focusNode,
    this.onSubmitted,
    this.onEditingComplete,
    this.onChanged,
    this.errorText,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final String? errorText;

  @override
  State<CustomTextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        errorText: widget.errorText,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
