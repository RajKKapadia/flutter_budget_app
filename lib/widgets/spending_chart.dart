import 'package:budget_app/models/item_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget {
  final List<Item> items;
  const SpendingChart({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> spendings = {};

    for (var item in items) {
      spendings.update(item.category, (value) => value + item.price,
          ifAbsent: () => item.price);
    }
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: spendings
                      .map(
                        (category, amount) => MapEntry(
                          category,
                          PieChartSectionData(
                            color: _getCategoryColor(category),
                            radius: 100.0,
                            title: 'Rs.${amount.toInt()}',
                            value: amount,
                            titleStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            showTitle: true,
                            titlePositionPercentageOffset: 0.75,
                          ),
                        ),
                      )
                      .values
                      .toList(),
                  sectionsSpace: 2.0,
                  centerSpaceRadius: 10.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: spendings.keys
                  .map(
                    (category) => _Indicator(
                      color: _getCategoryColor(category),
                      title: category,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Entertainment':
        return Colors.red[400];
      case 'Food':
        return Colors.green[400];
      case 'Transportations':
        return Colors.purple[400];
      default:
        return Colors.orange[400];
    }
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String title;

  _Indicator({
    this.color,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
