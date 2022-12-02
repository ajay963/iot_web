import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/Material.dart';

class NavDesktopView extends StatelessWidget {
  const NavDesktopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: MoveWindow(),
        ),
        Text(
          'Ultra Sonic System Info',
          style: txtTheme.labelMedium,
        ),
        const SizedBox(height: 40),
        Text(
          '64 cm',
          style: txtTheme.displayMedium,
        ),
        Text(
          'obstacle',
          style: txtTheme.bodyMedium,
        ),
      ],
    );
  }
}
