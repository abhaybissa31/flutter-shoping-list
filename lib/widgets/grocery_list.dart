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
  var _isLoading = true;
  String? _error;
  // String? _snackBarError;

  void _loadData() async {
    final url = Uri.https(
      "flutter-shopping-list-e46cf-default-rtdb.asia-southeast1.firebasedatabase.app",
      "shopping-list.json"
    );

    try {
      final res = await http.get(url).timeout(const Duration(seconds: 12));
      
      if (res.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data, please try again later or contact support if the problem persists.";
          _isLoading = false;
        });
        return;
      }

      if(res.body == 'null'){
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> jsonres = json.decode(res.body);
      final List<GroceryItem> _fetchedItems = [];

      for (var items in jsonres.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == items.value['category'])
            .value;
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
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "Loading data took too long. Please check the Internet or try again later.";
        _isLoading = false;
      });
    }
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
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
     setState(() {
          _groceryItems.remove(item);
        });
    final url = Uri.https(
      "flutter-shopping-list-e46cf-default-rtdb.asia-southeast1.firebasedatabase.app",
      "shopping-list/${item.id}.json"
    );
   final res = await http.delete(url);
   if (res.statusCode >= 400) {
        setState(() {
          // _snackBarError = "Unable to delete item, Please try again later.";  
          _groceryItems.insert(index,item);
        }
        );
   }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items added yet'),
    );

    if (_isLoading) {
      content = const Center(
        child: Column(
          children: [
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 10),
            Text('Please wait while your list is loading.')
          ],
        ),
      );
    } else if (_groceryItems.isNotEmpty) {
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
    } else if (_error != null) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            children: [
              const Icon(
                Icons.error_rounded,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 15),
              Text(_error!)
            ],
          ),
        ),
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
                  const SizedBox(height: 1),
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
                const SizedBox(width: 25),
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
                // SnackBar(content: Text(_snackBarError!)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
