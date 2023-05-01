import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../lib_grocery_list/data/categories.dart';

import '../models/grocery_item.dart';
import '../widgets/new_item.dart';
import '../constants.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryList = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    try {
      final url = Uri.parse('$apiUrl/shopping-list');
      final response = await http.get(url);

      final List<dynamic> data = json.decode(response.body);
      // print(data);
      final List<GroceryItem> loadedItems = [];

      for (final item in data) {
        final category = categories.entries
            .firstWhere((element) => element.value.title == item['category'])
            .value;

        loadedItems.add(
          GroceryItem(
            id: item['id'].toString(),
            name: item['name'],
            quantity: item['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryList = loadedItems;
        _error = null;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = 'Failed to fetch data. please try again';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addItem() async {
    final result = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    // _loadItems();

    if (result == null) return;

    setState(() {
      _groceryList.add(result);
    });
  }

  void _removeItem(GroceryItem item) async {
    final url = Uri.parse('$apiUrl/shopping-list/${item.id}');
    await http.delete(url);
    setState(() {
      _groceryList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

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

    if (_error != null) {
      content = Center(
        child: Text(_error!),
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
