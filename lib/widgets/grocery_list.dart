import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart'; // Assuming this file exists

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

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
      body: Column(
        children: [
          Center(
            child:  Image.asset("lib/assets/8882813.jpg",width:300,height: 250,),
          ),
          const SizedBox(height: 10,),
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
