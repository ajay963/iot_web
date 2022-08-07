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
    return Column(
      children: [
        WindowTitleBarBox(
          child: Container(
            height: 34,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xff333333),
            child: MoveWindow(
              child: Align(
                alignment: Alignment.centerLeft,
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
                              CloseWindowButton(),
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
