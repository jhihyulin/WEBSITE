import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widget/scaffold_messenger.dart';

class CustomImage extends StatefulWidget {
  const CustomImage({
    Key? key,
    required this.src,
    this.height,
    this.width,
  }) : super(key: key);

  final String src;
  final double? height;
  final double? width;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.src.startsWith('assets/')
          ? kDebugMode
              ? widget.src
              : 'https://raw.githubusercontent.com/jhihyulin/WEBSITE/deploy/${widget.src}'
          : widget.src,
      isAntiAlias: true,
      height: widget.height,
      width: widget.width,
      frameBuilder: (BuildContext context, Widget child, int? frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(
            seconds: 1,
          ),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        CustomScaffoldMessenger.showErrorMessageSnackBar(
            context, 'Error: Image Loading Failed.\nException: $exception');
        debugPrint('Error: Image Loading Failed.\nException: $exception');
        return Text('😢\n$exception');
      },
    );
  }
}
