import 'dart:convert';
import 'dart:io';
import 'package:budget_app/models/failure_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:budget_app/models/item_model.dart';
import 'package:budget_app/repositories/base_budget_repository.dart';
import 'package:intl/intl.dart';

class BudgetRepository extends BaseBudgetRepository {
  final http.Client _client;

  BudgetRepository({http.Client client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  @override
  Future<void> addItem({Item item}) async {
    try {
      await http.post(
        Uri.parse(
            'https://api.airtable.com/v0/${dotenv.env['AIRTABLE_APPID']}/tracker'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${dotenv.env['AIRTABLE_APIKEY']}',
        },
        body: jsonEncode(<String, dynamic>{
          'records': [
            {
              "fields": {
                "name": item.name,
                "category": item.category,
                "price": item.price,
                "date": '${DateFormat.yMMMd().format(item.date)}'
              }
            }
          ],
        }),
      );
    } catch (e) {
      print('Error at addItem --> $e');
      throw const Failure(message: 'Something is wrong with add item.');
    }
  }

  @override
  Future<List<Item>> getItems() async {
    try {
      final uri =
          'https://api.airtable.com/v0/${dotenv.env['AIRTABLE_APPID']}/tracker?maxRecords=100&view=Grid%20view';
      final http.Response response = await _client.get(
        Uri.parse(uri),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${dotenv.env['AIRTABLE_APIKEY']}'
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List records = data['records'];
        final List<Item> items = [];
        for (var record in records) {
          items.add(Item.fromMap(record['fields']));
        }
        return items;
      } else {
        throw const Failure(message: 'Something went wrong.');
      }
    } catch (e) {
      print('Error at getItems --> $e');
      throw const Failure(message: 'Something went wrong.');
    }
  }
}
