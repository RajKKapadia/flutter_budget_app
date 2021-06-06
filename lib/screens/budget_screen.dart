import 'package:budget_app/models/failure_model.dart';
import 'package:budget_app/models/item_model.dart';
import 'package:budget_app/repositories/budget_repository.dart';
import 'package:budget_app/screens/add_item_screen.dart';
import 'package:budget_app/widgets/custom_listview.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  static const String routeName = '/budgetScreen';
  const BudgetScreen({Key key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepository().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItems = BudgetRepository().getItems();
          setState(() {});
        },
        child: FutureBuilder(
          future: _futureItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data;
              return CustomListView(
                items: items,
              );
            } else if (snapshot.hasError) {
              final Failure failure = snapshot.error;
              return Center(
                child: Text(failure.message),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddItem(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
