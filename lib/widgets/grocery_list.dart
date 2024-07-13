import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/model/grocery_item_model.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];

  void _loadData() async {
    final url = Uri.https(
        "flutter-shopping-list-e46cf-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping-list.json");
    final res = await http.get(url);
    final Map<String, dynamic> jsonres = json.decode(res.body);
    final List<GroceryItem> _fetchedItems = [];
    for (var items in jsonres.entries) {
      final category = categories.entries.firstWhere((catItem) => catItem.value.title == items.value['category']).value;
      _fetchedItems.add(
        GroceryItem(
          id: items.key,
          name: items.value['name'],
          quantity: items.value['quantity'],
          category: category),
          );
    }
    setState(() {
    _groceryItems = _fetchedItems;  
    });
    print('----------------------------------------------------------------------');
    print('data loaded');
    print('----------------------------------------------------------------------');

  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _createNewItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddNewItem(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });

    // print(_groceryItems);

    // _loadData();
  }

  void _removeItem(GroceryItem item) {
        // final url = Uri.https(
        // "flutter-shopping-list-e46cf-default-rtdb.asia-southeast1.firebasedatabase.app",
        // "shopping-list.json");
        // http.delete(url);
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items added yet'),
    );

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          final item = _groceryItems[index];
          return Dismissible(
            key: ValueKey(item.id),
            onDismissed: (direction) {
              _removeItem(item);
            },
            child: ListTile(
              title: Text(item.name),
              leading: Container(
                height: 24,
                width: 24,
                color: item.category.color,
              ),
              trailing: Text(item.quantity.toString()),
            ),
          );
        },
      );
    }

    var mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        shadowColor: Color.fromARGB(255, 253, 246, 246),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Center(
          child: Text(
            "My Shopping List",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
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
                    height: 1,
                  ),
                  Expanded(
                    child: content,
                  )
                ],
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
                    text: "Create new item",
                    style: const TextStyle(fontSize: 20),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _createNewItem(context);
                      },
                  ),
                ),
                SizedBox(
                  width: mobileWidth - 230,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Colors.white,
                  iconSize: 36,
                  onPressed: () {
                    _createNewItem(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
