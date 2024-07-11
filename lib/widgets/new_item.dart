import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/widgets/grocery_list.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key});
  @override
  State<AddNewItem> createState() {
    return _AddNewItemState();
  }
}

class _AddNewItemState extends State<AddNewItem> {
  @override
  Widget build(BuildContext context) {
    void _showShoppingItems(BuildContext context) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GroceryList(),
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
      ));
    }

    final mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5,
        // backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Add New Shopping Item",
            // textAlign: TextAlign.center,
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
                    //  SingleChildScrollView(
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.add_shopping_cart),
                                    // alignLabelWithHint: true,
                                    // hintText: "Please Enter the Name of Item",
                                    // hintFadeDuration: Duration(seconds: 4),
                                    hintTextDirection: TextDirection.rtl,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    label: const Text('Name'),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length <= 1 ||
                                        value.trim().length > 50) {
                                      return 'Value must be between 1 and 50 characters';
                                    }
                                  },
                                ),
                                TextFormField(
                                  maxLength: 4,
                                  decoration: InputDecoration(
                                    label: const Text('Quantity'),
                                    prefixIcon: const Icon(Icons.numbers_sharp),
                                    hintText: "Enter Quantity of item",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  initialValue: '1',
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        int.tryParse(value) == null ||
                                        int.tryParse(value)! <= 0) {
                                      return 'Value must be between 1 and 50 characters';
                                    }
                                  },
                                ),
                                DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    label: const Text("Category"),
                                    prefixIcon: const Icon(Icons.category),
                                    hintText: "Select Category",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: [
                                    for (final Category in categories.entries)
                                      DropdownMenuItem(
                                          value: Category.value,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                color: Category.value.color,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(Category.value.title)
                                            ],
                                          ))
                                  ],
                                  onChanged: (value) {},
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text("Reset"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
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
                    //  )
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
                        ..onTap = () {
                          _showShoppingItems(context);
                        }),
                ),
                // IconButton.outlined(onPressed: onPressed, icon)
                // const Text('Create new list',
                //     style: TextStyle(color: Colors.white, fontSize: 22),
                //     textAlign: TextAlign.right),
                SizedBox(
                  width: mobileWidth - 178,
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.white,
                  iconSize: 36,
                  onPressed: () {
                    _showShoppingItems(context);
                  },
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
