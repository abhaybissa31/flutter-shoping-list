import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/model/category_model.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key});
  @override
  State<AddNewItem> createState() {
    return _AddNewItemState();
  }
}

class _AddNewItemState extends State<AddNewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  _saveItem(bool showShoppingList) async{
    if (showShoppingList == false) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print("saved");

        final url = Uri.https(
            "flutter-shopping-list-e46cf-default-rtdb.asia-southeast1.firebasedatabase.app",
            "shopping-list.json");
       final res = await http.post(
          url,
          headers: {'Content-type': 'application/json'},
          body: json.encode(
            {
              'name': _enteredName,
              'quantity': _enteredQuantity,
              'category': _selectedCategory.title,
            },
          ),
        );

        print(res.body);
        print(res.statusCode);
        
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pop();
        // final newGroceryItem = GroceryItem(
        //   id: DateTime.now().toString(),
        //   name: _enteredName,
        //   quantity: _enteredQuantity,
        //   category: _selectedCategory,
        // );

        // Navigator.of(context).pop(newGroceryItem);
        return false;
      }
    } else {
      Navigator.of(context).pop();
      return true;
    }
    return false;
  }

  void _onSaveItemPressed() {
    _saveItem(false);
  }

  void _onShowCartPressed() {
    _saveItem(true);
  }

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        shadowColor: Color.fromARGB(255, 253, 246, 246),
        title: const Center(
          child: Text(
            "Add New Shopping Item",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            flex: 35,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "lib/assets/3 (4).png",
                        width: 350,
                        height: 300,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.add_shopping_cart),
                                    hintTextDirection: TextDirection.rtl,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    label: const Text('Name'),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().isEmpty ||
                                        value.trim().length > 50) {
                                      return 'Value must be between 1 and 50 characters';
                                    }
                                  },
                                  onSaved: (value) {
                                    _enteredName = value!;
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  maxLength: 4,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    label: const Text('Quantity'),
                                    prefixIcon: const Icon(Icons.numbers_sharp),
                                    hintText: "Enter Quantity of item",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  initialValue: _enteredQuantity.toString(),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        int.tryParse(value) == null ||
                                        int.tryParse(value)! <= 0) {
                                      return 'Must be a valid, Positive number';
                                    }
                                  },
                                  onSaved: (value) {
                                    _enteredQuantity = int.parse(value!);
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                DropdownButtonFormField(
                                  value: _selectedCategory,
                                  decoration: InputDecoration(
                                    label: const Text("Category"),
                                    prefixIcon: const Icon(Icons.category),
                                    hintText: "Select Category",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: [
                                    for (final category in categories.entries)
                                      DropdownMenuItem(
                                        value: category.value,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              color: category.value.color,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(category.value.title)
                                          ],
                                        ),
                                      )
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _formKey.currentState!.reset();
                                      },
                                      child: const Text("Reset"),
                                    ),
                                    ElevatedButton(
                                      onPressed: _onSaveItemPressed,
                                      child: const Text('Add Item'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const SizedBox(
                  width: 25,
                ),
                RichText(
                  text: TextSpan(
                    text: "Show Cart",
                    style: const TextStyle(fontSize: 20),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _onShowCartPressed,
                  ),
                ),
                SizedBox(
                  width: mobileWidth - 178,
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.white,
                  iconSize: 36,
                  onPressed: _onShowCartPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
