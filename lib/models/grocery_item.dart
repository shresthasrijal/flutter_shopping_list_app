import 'package:proj9_shopping_list/models/category.dart';

class GroceryItem{
  GroceryItem({
    required this.id,
    required this.category,
    required this.name,
    required this.quantity,
    this.done = false,
  });

  final String id;
  final String name;
  final Category category;
  final int quantity;
  bool done;
}