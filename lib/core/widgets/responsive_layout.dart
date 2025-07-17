import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;

  const ResponsiveLayout({
    super.key,
    required this.mobileScaffold,
    required this.tabletScaffold,
    required this.desktopScaffold,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktopScaffold;
        } else if (constraints.maxWidth >= 650) {
          return tabletScaffold;
        } else {
          return mobileScaffold;
        }
      },
    );
  }
}

class SplitView extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  final double ratio;

  const SplitView({
    super.key,
    required this.leftChild,
    required this.rightChild,
    this.ratio = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: (ratio * 10).toInt(),
          child: leftChild,
        ),
        Container(
          width: 1,
          color: Colors.grey[300],
        ),
        Expanded(
          flex: ((1 - ratio) * 10).toInt(),
          child: rightChild,
        ),
      ],
    );
  }
}
