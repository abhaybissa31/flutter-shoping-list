import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart'; // Assuming this file exists

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
        title: const Center(
          child: Text(
            "My Shopping List",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewItem,
        tooltip: 'Create New Shopping Item',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        color: const Color.fromARGB(255, 62, 160, 240),
        child: Container(
          height: 40.0,
          child: const Center(
            child: Text(
              'Create New Shopping Item',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
      ),
      body: Column(
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
          ),
        ],
      ),
    );
  }
}
