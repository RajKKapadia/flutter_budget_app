import 'package:budget_app/models/item_model.dart';
import 'package:budget_app/widgets/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomListView extends StatelessWidget {
  final List<Item> items;
  const CustomListView({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return SpendingChart(
            items: items,
          );
        }
        final item = items[index - 1];
        return Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
            border: Border.all(
              width: 2.0,
              color: _getCategoryColor(item.category),
            ),
          ),
          child: ListTile(
            title: Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                '${item.category} - ${DateFormat.yMd().format(item.date)}'),
            trailing: Text(
              'Rs. ${item.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
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
