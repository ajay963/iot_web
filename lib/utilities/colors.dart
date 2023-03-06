import 'package:flutter/material.dart';
import '../models/gradient_model.dart';

const Color themeColor1 = Color(0xFFAF27EC);
const Color themeColor2 = Color(0xFF7578FC);
const Color kTxtWhite = Color(0xffFeFeFe);
const Color kMdGrey = Color(0xff666666);
const Color kLtGrey = Color(0xffAAAAAA);
const Color kDarkBlack = Color(0xff1b1b1b);
const Color kspaceBlack = Color(0xff333333);
const Color kJustWhite = Color(0xffeeeeee);

const Color kgreenShade1 = Color(0xff80ED99);
const Color kgreenShade2 = Color(0xff57CC99);
const Color kgreenShade3 = Color(0xff38A3A5);
const Color kgreenShade4 = Color(0xff22577A);

class CustomColors {
  static const Color blackShade1 = Color(0xff1b1b1b);
  static const Color blackShade2 = Color(0xff333333);
  static const Color greyShade1 = Color(0xff666666);
  static const Color greyShade2 = Color(0xff777777);
  static const Color greyShade3 = Color(0xffAAAAAA);
  static const Color orangeShade1 = Color(0xffF09819);
  static const Color orangeShade2 = Color(0xffFF512F);
  static const Color blueShade1 = Color(0xff8E2DE2);
  static const Color blueShade2 = Color(0xff4A00E0);
  static const Color greenShade1 = Color(0xff38EF7D);
  static const Color greenShade2 = Color(0xff11998E);
  static const Color magentaShade1 = Color(0xffFC6767);
  static const Color magentaShade2 = Color(0xffEC008C);
}

class CustomGradients {
  static GradientModel orangeGradient = GradientModel(
      color1: CustomColors.orangeShade1, color2: CustomColors.orangeShade2);
  static GradientModel blueGradient = GradientModel(
      color1: CustomColors.blueShade1, color2: CustomColors.blueShade2);
  static GradientModel greenGradient = GradientModel(
      color1: CustomColors.greenShade1, color2: CustomColors.greenShade2);
  static GradientModel magentaGradient = GradientModel(
      color1: CustomColors.magentaShade1, color2: CustomColors.magentaShade2);

  static List<GradientModel> gradientList = [
    orangeGradient,
    blueGradient,
    greenGradient,
    magentaGradient,
  ];
}
