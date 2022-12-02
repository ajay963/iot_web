import 'package:flutter/material.dart';

class NoConenction extends StatelessWidget {
  final int idx;
  const NoConenction({Key? key, required this.idx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        // height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/char/booth.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "it's seems you are not connected",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 5),
            Text(
              "re-connecting in " + (10 - idx % 10).toString() + " sec",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
