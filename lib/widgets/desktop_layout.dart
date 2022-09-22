import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class DesktopSplitView extends StatelessWidget {
  final String title;
  final Widget leftPannel;
  final Widget rightPannel;
  const DesktopSplitView(
      {Key? key,
      required this.title,
      required this.leftPannel,
      required this.rightPannel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    WindowButtonColors minButtonColor = WindowButtonColors(
        normal: Colors.green, mouseOver: Colors.lightGreen[400]);
    WindowButtonColors closeButtonColor = WindowButtonColors(
        normal: Colors.red, mouseOver: Colors.deepOrange[300]);

    return Column(
      children: [
        WindowTitleBarBox(
          child: Container(
            height: 34,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: MoveWindow(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 240,
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  color: Colors.red,
                                ),
                                CloseWindowButton(
                                  colors: closeButtonColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  color: Colors.green,
                                ),
                                MinimizeWindowButton(
                                  colors: minButtonColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '  ' + title,
                        style: txtTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: Row(
          children: [
            Expanded(child: leftPannel),
            SizedBox(width: 400, child: rightPannel)
          ],
        ))
      ],
    );
  }
}

class DesktopSingleView extends StatelessWidget {
  final String title;
  final Widget bottomPannel;

  const DesktopSingleView({
    Key? key,
    required this.title,
    required this.bottomPannel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    WindowButtonColors minButtonColor = WindowButtonColors(
        normal: Colors.transparent, mouseOver: Colors.transparent);
    WindowButtonColors closeButtonColor = WindowButtonColors(
        normal: Colors.transparent, mouseOver: Colors.transparent);

    return Column(
      children: [
        WindowTitleBarBox(
          child: Container(
            height: 34,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.2),
            child: MoveWindow(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Color(0xffFF0000),
                                    Color(0xffFD7919),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )),
                              ),
                              Opacity(
                                opacity: 0,
                                child: CloseWindowButton(
                                  colors: closeButtonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Color(0xff00FF00),
                                    Color(0xff1AECAD),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )),
                              ),
                              Opacity(
                                opacity: 0,
                                child: MinimizeWindowButton(
                                  colors: minButtonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                    Text(
                      '  ' + title,
                      style: txtTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child: bottomPannel)
      ],
    );
  }
}
