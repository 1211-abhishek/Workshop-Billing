import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/billing_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BillingProvider>(context, listen: false).fetchSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Consumer<BillingProvider>(
        builder: (context, billingProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (billingProvider.salesData.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: billingProvider.salesData
                              .map((e) => e.total)
                              .reduce((a, b) => a > b ? a : b) * 1.2,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  rod.toY.round().toString(),
                                  const TextStyle(color: Colors.white),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < billingProvider.salesData.length) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(billingProvider.salesData[index].day),
                                    );
                                  } 
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: billingProvider.salesData
                              .asMap()
                              .map((index, data) => MapEntry(
                                index,
                                BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.total,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                              ))
                              .values
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
