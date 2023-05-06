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
  static const Color yellowShade1 = Color(0xffFFD200);
  static const Color yellowShade2 = Color(0xffF7971E);
  static const Color greenShade3 = Color(0xff35E97E);
  static const Color greenShade4 = Color(0xff139E8D);
  static const Color redShade1 = Color(0xffFF416B);
  static const Color redShade2 = Color(0xffFF4B2C);
  static const Color blueShade3 = Color(0xff8E2DE2);
  static const Color blueShade4 = Color(0xff4A00E0);

  static const List<Color> colorList = [
    orangeShade1,
    redShade1,
    greenShade1,
    yellowShade2,
    blueShade1,
    orangeShade2,
    magentaShade1,
    blueShade4
  ];
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
  static GradientModel yellowGradient = GradientModel(
      color1: CustomColors.yellowShade1, color2: CustomColors.yellowShade2);
  static GradientModel waterGradient = GradientModel(
      color1: CustomColors.blueShade3, color2: CustomColors.blueShade4);
  static GradientModel lavaGradient = GradientModel(
      color1: CustomColors.redShade1, color2: CustomColors.redShade2);
  static GradientModel naturegreenGradient = GradientModel(
      color1: CustomColors.greenShade3, color2: CustomColors.greenShade4);

  static List<GradientModel> gradientList = [
    lavaGradient,
    blueGradient,
    // greenGradient,
    magentaGradient,
  ];
}
