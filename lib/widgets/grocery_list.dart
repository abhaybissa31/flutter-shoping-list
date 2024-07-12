import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/model/grocery_item_model.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _createNewItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddNewItem(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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

    print(_groceryItems);
  }

  @override
  Widget build(BuildContext context) {
    var mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        automaticallyImplyLeading: false,
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
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _groceryItems.length,
                      itemBuilder: (ctx, index) {
                        final item = _groceryItems[index];
                        return ListTile(
                          title: Text(item.name),
                          leading: Container(
                            height: 24,
                            width: 24,
                            color: item.category.color,
                          ),
                          trailing: Text(item.quantity.toString()),
                        );
                      },
                    ),
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
