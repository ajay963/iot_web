import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iot/provider/light_data.dart';
import 'package:iot/widgets/boxes.dart';
import 'package:provider/provider.dart';

class AdvancePage extends StatelessWidget {
  const AdvancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _colorData = Provider.of<LightData>(context);
    final _textThemeData = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Selected Color',
              style: _textThemeData.headline2,
            ),
            const SizedBox(height: 20),
            Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [_colorData.getColor1, _colorData.getColor2],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight),
                  borderRadius: BorderRadius.circular(20),
                )),
            const SizedBox(height: 20),
            Text('HEXcode', style: _textThemeData.bodyText1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_colorData.getColorInString,
                    style: TextStyle(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff343434))),
                const SizedBox(width: 20),
                Ink(
                  height: 50,
                  width: 50,
                  child: InkWell(
                    splashColor: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      Clipboard.setData(
                          ClipboardData(text: _colorData.getColorInString));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black38,
                          content: Text(
                            'ColorCode Copied',
                            style: _textThemeData.bodyText1,
                          )));
                    },
                    child: const Icon(
                      Icons.copy,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffcccccc),
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
            Text('Tints', style: _textThemeData.headline2),
            const SizedBox(height: 40),
            Text('Shades', style: _textThemeData.headline2),
            const SizedBox(height: 40),
            Text('Color Wheel', style: _textThemeData.headline2),
            const SizedBox(height: 20),
            ColorPicker(
              color: _colorData.getColor1,
              onColorChanged: (Color color) =>
                  _colorData.setColor1(colorData: color),
              onColorChangeEnd: (Color color) =>
                  _colorData.addRecentColor(colorData: color),
              wheelDiameter: MediaQuery.of(context).size.width * 0.8,
              wheelWidth: 40,
              borderRadius: 30,
              enableShadesSelection: false,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.wheel: true,
                ColorPickerType.accent: false,
                ColorPickerType.primary: false
              },
            ),
            const SizedBox(height: 40),
            Text('Recent Colors', style: _textThemeData.headline2),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 5,
              ),
              itemCount: _colorData.getRecentColor.length,
              itemBuilder: (BuildContext context, int index) {
                return ColorBox(
                    onTap: () {
                      _colorData.setColor1(
                          colorData: _colorData.getRecentColor[index]);
                      _colorData.setColor2(
                          colorData: _colorData.getRecentColor[index]);
                    },
                    colorCode: _colorData.getRecentColor[index]);
              },
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}
