import 'package:flutter/material.dart';
import 'package:proj9_shopping_list/models/grocery_item.dart';
import 'package:proj9_shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _setDone(int index, bool isChecked) {
    setState(() {
      _groceryItems[index].done = isChecked;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: _groceryItems.isEmpty
          ? Center(
              child: Text(
                'Empty list, add some items!',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) {
                final groceryItem = _groceryItems[index];
                return Dismissible(
                  key: ValueKey(groceryItem.id),
                  onDismissed: (direction) {
                    setState(() {
                      _groceryItems.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${groceryItem.name} dismissed'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              _groceryItems.add(groceryItem);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: _groceryItems[index].done,
                          onChanged: (isChecked) =>
                              _setDone(index, isChecked ?? false),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.square,
                          color: _groceryItems[index].category.color,
                          size: 24,
                        ),
                      ],
                    ),
                    title: Text(
                      _groceryItems[index].name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      _groceryItems[index].quantity.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              }),
    );
  }
}
