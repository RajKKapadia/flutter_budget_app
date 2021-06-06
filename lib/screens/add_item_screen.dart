import 'package:budget_app/models/item_model.dart';
import 'package:budget_app/repositories/budget_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddItem extends StatefulWidget {
  static const String routeName = 'addItem';

  AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _categories = [
    'Food',
    'Entertainment',
    'Transportations',
    'Any',
  ];

  String _name, _category, _price;

  DateTime _date;

  bool _flag = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    setState(() {
      _date = pickedDate;
      _flag = true;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new item'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Item name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DropdownButtonFormField(
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            child: Text(category),
                            value: category,
                          ),
                        )
                        .toList(),
                    hint: Text('Select category'),
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Price of the item',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _price = value;
                      });
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.date_range_outlined,
                          size: 35.0,
                        ),
                        onPressed: () => _selectDate(context),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (!_flag)
                        Text(
                          'Select a date',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                      if (_flag)
                        Text(
                          '${DateFormat.yMMMd().format(_date)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextButton(
                    onPressed: () {
                      BudgetRepository().addItem(
                        item: Item(
                          name: _name,
                          category: _category,
                          date: _date,
                          price: double.parse(_price),
                        ),
                      );
                      _formKey.currentState.reset();
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _flag = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Item created'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      height: 50.0,
                      width: 100.0,
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
