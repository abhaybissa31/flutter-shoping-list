import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  void _createNewItem() {
    // Handle the action for creating a new item here
    print("Create new item tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                // borderRadius: BorderRadius.circular(65)
                borderRadius: const BorderRadius.only(
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
                      itemCount: groceryItems.length,
                      itemBuilder: (ctx, index) {
                        final item = groceryItems[index];
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
          const Expanded(
            flex: 3,
            child: Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text('Create new list',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                    textAlign: TextAlign.right),
                SizedBox(
                  width: 180,
                ),
                Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            ),
            // ),
          ),
        ],
      ),
    );
  }
}
