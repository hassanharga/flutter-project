import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meals/models/grocery_item.dart';

import '../constants.dart';
import '../data/categories.dart';
import '../models/category.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  var _name = '';
  var _quantity = 1;
  var _selectedCategory = categories[Categories.vegetables];

  var _isSending = false;

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final url = Uri.parse('$apiUrl/shopping-list');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _name,
          'quantity': _quantity,
          'category': _selectedCategory!.title,
        }),
      );
      setState(() {
        _isSending = false;
      });
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);

      if (!context.mounted) return;

      Navigator.of(context).pop(
        GroceryItem(
          id: data['id'].toString(),
          name: data['name'],
          quantity: data['quantity'],
          category: _selectedCategory!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // in form use TextFormField instead of TextField
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (newValue) => _name = newValue!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) => _quantity = int.parse(newValue!),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! < 0) {
                          return 'Must be positive number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: categories.entries
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat.value,
                              child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    color: cat.value.color,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(cat.value.title),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() {
                        _selectedCategory = val;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        _isSending ? null : _formKey.currentState!.reset(),
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveForm,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Item'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
