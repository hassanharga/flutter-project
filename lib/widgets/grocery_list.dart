import 'package:flutter/material.dart';

import '../models/grocery_item.dart';
import '../widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryList = [];

  void _addItem() async {
    final result = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (result == null) return;

    setState(() {
      _groceryList.add(result);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items'),
    );

    if (_groceryList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (ctx, idx) => Dismissible(
          key: ValueKey(_groceryList[idx].id),
          onDismissed: (direction) {
            _removeItem(_groceryList[idx]);
          },
          child: ListTile(
            title: Text(_groceryList[idx].name),
            leading: Container(
              height: 24,
              width: 24,
              color: _groceryList[idx].category.color,
            ),
            trailing: Text(_groceryList[idx].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          )
        ],
      ),
      body: content,
    );
  }
}
