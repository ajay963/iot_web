import 'package:flutter/cupertino.dart';

class ColorList extends ChangeNotifier {
  List<Color> colorsList = [
    const Color(0xffFF21CE),
    const Color(0xff37FF63),
    const Color(0xff00FFF0),
    const Color(0xff3B5AFB),
    const Color(0xffFF21CE),
    const Color(0xffB04CFF),
    const Color(0xffFF6C6C),
    const Color(0xffFFD231),
    const Color(0xffFFD231)
  ];
  List<Color> get colorList => colorsList;
  void addColors({required Color colorCode}) {
    colorsList.add(colorCode);
    notifyListeners();
  }

  void removeColor() {
    colorsList.removeLast();
    notifyListeners();
  }
}
