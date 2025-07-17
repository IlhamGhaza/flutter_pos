import 'package:flutter/material.dart';
import 'package:flutter_pos/presentation/home/pages/home_page.dart';
import 'package:flutter_pos/presentation/order/pages/order_page.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side - Home Page (Products)
          Expanded(
            flex: 6, // Slightly smaller than desktop to give more space to orders
            child: HomePage(),
          ),
          
          // Divider
          Container(
            width: 1,
            color: Colors.grey[300],
          ),
          
          // Right side - Order Page
          Expanded(
            flex: 4, // Slightly larger than desktop to give more space to orders
            child: OrderPage(),
          ),
        ],
      ),
    );
  }
}
