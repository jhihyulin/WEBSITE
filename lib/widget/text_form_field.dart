import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTapOutside,
    this.onFieldSubmitted,
    this.minLines,
    this.maxLines,
    this.readOnly = false,
    this.enabled = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onFieldSubmitted;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;
  final bool enabled;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffix: widget.suffix,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        enabled: widget.enabled,
      ),
      scrollPhysics: const BouncingScrollPhysics(),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTapOutside: widget.onTapOutside,
      onFieldSubmitted: widget.onFieldSubmitted,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
    );
  }
}
