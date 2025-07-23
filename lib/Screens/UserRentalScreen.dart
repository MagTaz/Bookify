import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils/MainColors.dart';
import '../Utils/TextStyle.dart';

class UserRentalsScreen extends StatelessWidget {
  const UserRentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Book Rentals')),
        body: Center(child: Text('You must be logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Rental History')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('rentals')
                .where('user_id', isEqualTo: user.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No rentals found.'));
          }

          final rentals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
              final data = rental.data() as Map<String, dynamic>;

              if (!data.containsKey('timestamp') || data['timestamp'] == null) {
                return SizedBox.shrink();
              }

              final title = data['book_title'] ?? '';
              final rentalDate = data['rental_date']?.toDate();
              final returnDate = data['return_date']?.toDate();
              final status = data['status'] ?? 'pending';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    title,
                    style: Text_Style.textStyleBold(Colors.black87, 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text("From: ${_formatDate(rentalDate)}"),
                      Text("To: ${_formatDate(returnDate)}"),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Status: ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: _getStatusText(status),
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  leading: Icon(Icons.book, color: MainColors.mainColor),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return "${date.year}/${date.month}/${date.day}";
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'returned':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'returned':
        return 'Returned';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
