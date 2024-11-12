import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/earnings.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Earnings?>(
      future: AdminServices().getEarnings(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          return Column(
            children: [
              Text("Total: ₹${formatNumber(snapshot.data!.totalEarnings)}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: _generateSections(snapshot.data!),
                    centerSpaceRadius: 100,
                    sectionsSpace: 0,
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }

  List<PieChartSectionData> _generateSections(Earnings earnings) {
    final dataMap = {
      'Mobiles': earnings.mobileEarnings,
      'Essentials': earnings.essentialEarnings,
      'Appliances': earnings.applianceEarnings,
      'Books': earnings.booksEarnings,
      'Fashion': earnings.fashionEarnings,
      'Electronics' : earnings.electronicsEarnings,
    };

    return dataMap.entries.map((entry) {
      final index = dataMap.keys.toList().indexOf(entry.key);
      final color = _getColor(index);

      return PieChartSectionData(
        color: color,
        showTitle: true,
        value: entry.value,
        title: '${entry.key}\n₹${formatNumber(entry.value)}',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        radius: 100,
      );
    }).toList();
  }

  Color _getColor(int index) {
    const colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.amber
    ];
    return colors[index % colors.length];
  }
}
