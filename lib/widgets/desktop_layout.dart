import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class DesktopView extends StatelessWidget {
  final String title;
  final Widget leftPannel;
  final Widget rightPannel;
  const DesktopView(
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
