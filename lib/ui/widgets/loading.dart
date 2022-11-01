import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoading extends StatelessWidget {
  final bool inAsyncCall;
  final opacity;
  final List<Color> colors;
  final Indicator indicatorType;
  final Offset offset;
  final bool dismissible;
  final Widget child;

  CustomLoading({
    Key key,
    @required this.inAsyncCall,
    this.opacity = 0.7,
    this.colors = const [
      AppColors.primary,

      /* Color(0XFF9D1457),
      Color(0XCC9D1457),
      Color(0XAA9D1457)*/
    ],
    this.indicatorType = Indicator.ballRotate,
    this.offset,
    this.dismissible = false,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inAsyncCall) return child;

    Widget layOutProgressIndicator;

    Widget indicator = LoadingIndicator(
        indicatorType: indicatorType,

        /// Required, The loading type of the widget
        colors: colors,
        strokeWidth: 1,

        /// Optional, The stroke of the line, only applicable to widget which contains line
        // backgroundColor: Colors.black,

        /// Optional, Background of the widget
        pathBackgroundColor: Colors.black

        /// Optional, the stroke backgroundColor
        );

    if (offset == null)
      layOutProgressIndicator = Center(child: indicator);
    else {
      layOutProgressIndicator = Positioned(
        child: indicator,
        left: offset.dx,
        top: offset.dy,
      );
    }

    return new Stack(
      children: [
        child,
        Opacity(
          child: new ModalBarrier(dismissible: dismissible, color: Colors.grey),
          opacity: opacity,
        ),
        Center(
            child: Container(
                height: 100, width: 100, child: layOutProgressIndicator))
      ],
    );
  }
}
