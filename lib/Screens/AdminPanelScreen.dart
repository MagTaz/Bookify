import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:recommendation/Screens/AddBookScreen.dart';
import 'package:recommendation/Screens/LoginScreen.dart';
import '../Utils/MainColors.dart';
import '../Utils/TextStyle.dart';
import 'AdminBooksScreen.dart';

import 'AdminOrdersScreen.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: MainColors.mainColor,
      appBar: AppBar(
        backgroundColor: MainColors.mainColor,
        title: Text(
          'Admin panel',
          style: Text_Style.textStyleNormal(Colors.white70, 25),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.logout, color: Colors.white70),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 5),
          ],
        ),
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, Admin",
              style: Text_Style.textStyleBold(MainColors.mainColor, 24),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                childAspectRatio: 2.3,
                crossAxisCount: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildCard(
                    context,
                    icon: Icons.library_books,
                    label: "Manage Books",
                    color: Colors.blue,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminBooksScreen()),
                        ),
                  ),
                  _buildCard(
                    context,
                    icon: Icons.add_box,
                    label: "Add Book",
                    color: Colors.green,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddBookScreen()),
                        ),
                  ),
                  _buildCard(
                    context,
                    icon: Icons.assignment,
                    label: "Rental Orders",
                    color: Colors.orange,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminOrdersScreen(),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color.withOpacity(0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: Text_Style.textStyleBold(color, 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
