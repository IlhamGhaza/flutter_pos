import 'package:flutter/material.dart';
import 'package:flutter_pos/presentation/home/pages/home_page.dart';
import 'package:flutter_pos/presentation/order/pages/order_page.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side - Home Page (Products)
          Expanded(
            flex: 7,
            child: HomePage(),
          ),
          
          // Divider
          Container(
            width: 1,
            color: Colors.grey[300],
          ),
          
          // Right side - Order Page
          Expanded(
            flex: 5,
            child: OrderPage(),
          ),
        ],
      ),
    );
  }
}
