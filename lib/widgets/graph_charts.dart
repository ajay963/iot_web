import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/temp.dart';

const Color shade1 = Color(0xff23b6e6);
const Color shade2 = Color(0xff02d39a);

class Charts extends StatelessWidget {
  final List<TempChartData> tempList;
  final String xAisLabel;
  final String yAxisLabel;
  const Charts(
      {Key? key,
      required this.tempList,
      required this.xAisLabel,
      required this.yAxisLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: <ChartSeries>[
        AreaSeries<TempChartData, double>(
          dataSource: tempList,
          xAxisName: xAisLabel,
          yAxisName: yAxisLabel,
          borderWidth: 3,
          borderGradient: const LinearGradient(
            colors: [shade1, shade2],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          gradient: LinearGradient(
            colors: [shade1.withOpacity(0.3), shade2.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          xValueMapper: (TempChartData tempData, _) => tempData.time,
          yValueMapper: (TempChartData tempData, _) => tempData.temp,
        ),
      ],
    );
  }
}
