import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];
    return AspectRatio(
      aspectRatio: 1.70,
      child: FlChart(
        chart: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalGrid: true,
//              drawHorizontalGrid: true,
              getDrawingVerticalGridLine: (value) {
                return const FlLine(
                  color: Color(0xff37434d),
                  strokeWidth: 0.3,
                );
              },
              getDrawingHorizontalGridLine: (value) {
                return const FlLine(
                  color: Color(0xff37434d),
                  strokeWidth: 0.3,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                textStyle: TextStyle(
                    color: const Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 2:
                      return 'MAR';
                    case 5:
                      return 'JUN';
                    case 8:
                      return 'SEP';
                  }

                  return '';
                },
                margin: 8,
              ),
              leftTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                  color: const Color(0xff67727d),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 1:
                      return '10k';
                    case 3:
                      return '30k';
                    case 5:
                      return '50k';
                  }
                  return '';
                },
                reservedSize: 28,
                margin: 12,
              ),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: Color(0xff37434d), width: 1)),
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 1),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3.5),
                  FlSpot(11, 4),
                ],
                isCurved: true,
                colors: gradientColors,
                barWidth: 1.0,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                ),
                belowBarData: BelowBarData(
                  show: true,
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
