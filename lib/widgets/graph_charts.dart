import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/temp.dart';

const Color shade1 = Color(0xff23b6e6);
const Color shade2 = Color(0xff02d39a);

const Color purpleShade1 = Color(0xffB224EF);
const Color purpleShade2 = Color(0xff7579FF);

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
      margin: const EdgeInsets.symmetric(vertical: 10),
      plotAreaBorderColor: Colors.transparent,
      enableAxisAnimation: true,
      series: <ChartSeries>[
        SplineAreaSeries<GraphData, double>(
          dataSource: list,
          xAxisName: xAisLabel,
          yAxisName: yAxisLabel,
          borderWidth: 4,
          isVisible: true,
          isVisibleInLegend: false,
          cardinalSplineTension: 0.2,
          borderGradient: const LinearGradient(
            colors: [purpleShade1, purpleShade2],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          gradient: LinearGradient(
            colors: [
              purpleShade1.withOpacity(0.3),
              purpleShade2.withOpacity(0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          xValueMapper: (GraphData data, _) => data.time,
          yValueMapper: (GraphData data, _) => data.value,
        ),
      ],
      primaryXAxis: CategoryAxis(
          isVisible: true,
          visibleMaximum: 4,
          rangePadding: ChartRangePadding.round,
          labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: CategoryAxis(
        isVisible: false,
        rangePadding: ChartRangePadding.none,
      ),
    );
  }
}
