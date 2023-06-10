import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.controlAffinity,
    this.controller,
    this.children = const <Widget>[],
  }) : super(key: key);

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final void Function(bool)? onExpansionChanged;
  final Widget? trailing;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final Alignment? expandedAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final ShapeBorder? shape;
  final ShapeBorder? collapsedShape;
  final Clip? clipBehavior;
  final ListTileControlAffinity? controlAffinity;
  final ExpansionTileController? controller;
  final List<Widget> children;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        leading: widget.leading,
        title: widget.title,
        subtitle: widget.subtitle,
        onExpansionChanged: widget.onExpansionChanged,
        trailing: widget.trailing,
        initiallyExpanded: widget.initiallyExpanded,
        maintainState: widget.maintainState,
        tilePadding: widget.tilePadding,
        expandedCrossAxisAlignment: widget.expandedCrossAxisAlignment,
        expandedAlignment: widget.expandedAlignment,
        childrenPadding: widget.childrenPadding,
        backgroundColor: widget.backgroundColor,
        collapsedBackgroundColor: widget.collapsedBackgroundColor,
        textColor: widget.textColor,
        collapsedTextColor: widget.collapsedTextColor,
        iconColor: widget.iconColor,
        collapsedIconColor: widget.collapsedIconColor,
        shape: widget.shape,
        collapsedShape: widget.collapsedShape,
        clipBehavior: widget.clipBehavior,
        controlAffinity: widget.controlAffinity,
        controller: widget.controller,
        children: widget.children,
      ),
    );
  }
}
