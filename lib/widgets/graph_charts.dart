import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/temp.dart';

const Color shade1 = Color(0xff23b6e6);
const Color shade2 = Color(0xff02d39a);

const Color orgShade1 = Color(0xffF12711);
const Color orgShade2 = Color(0xffF5AF19);

class Charts extends StatelessWidget {
  final List<GraphData> list;
  final String xAisLabel;
  final String yAxisLabel;
  const Charts(
      {Key? key,
      required this.list,
      required this.xAisLabel,
      required this.yAxisLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: <ChartSeries>[
        AreaSeries<GraphData, double>(
          dataSource: list,
          xAxisName: xAisLabel,
          yAxisName: yAxisLabel,
          borderWidth: 2,
          borderGradient: const LinearGradient(
            colors: [orgShade1, orgShade2],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          gradient: LinearGradient(
            colors: [orgShade1.withOpacity(0.3), orgShade2.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          xValueMapper: (GraphData data, _) => data.time,
          yValueMapper: (GraphData data, _) => data.value,
        ),
      ],
    );
  }
}
