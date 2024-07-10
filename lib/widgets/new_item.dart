import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    pageBuilder: (context, animation, secondaryAnimation) => const GroceryList(),
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
      body:Column(
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
                  text:  TextSpan(
                    text: "Show Cart",
                    style: const TextStyle(fontSize: 20),
                    recognizer: TapGestureRecognizer()
                    ..onTap = (){
                      _showShoppingItems(context);
                    }
                  ),
                  
                ),
                // IconButton.outlined(onPressed: onPressed, icon)
                // const Text('Create new list',
                //     style: TextStyle(color: Colors.white, fontSize: 22),
                //     textAlign: TextAlign.right),
                SizedBox(
                  width: mobileWidth - 178,
                ),
                IconButton(
                  icon:const Icon(Icons.add_circle),
                  color: Colors.white,
                  iconSize: 36,
                  onPressed:() {
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
