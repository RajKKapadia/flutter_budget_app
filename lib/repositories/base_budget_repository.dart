import 'package:budget_app/models/item_model.dart';

abstract class BaseBudgetRepository {
  Future<List<Item>> getItems();
  Future<void> addItem({Item item});
}
